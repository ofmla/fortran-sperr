program test_sperr_3d
  use, intrinsic :: iso_c_binding
  use :: sperr
  implicit none

  integer, parameter :: iunit = 99
  integer(c_int) :: sizeofreal, ios, ierr
  integer(c_int) :: is_float, mode, out_inc_header, out_is_float
  real(c_double), allocatable, target :: inbuf(:)
  type(c_ptr) :: ptr_in, bitstream, ptr_out
  real(c_double), pointer :: decomp_array(:)
  character, pointer :: buffer(:)
  real(c_double) :: quality
  integer(c_size_t) :: dimx, dimy, dimz, chunk_x, chunk_y, chunk_z
  integer(c_size_t) :: stream_len, out_dimx, out_dimy, out_dimz, nthreads

  ! Assign values to Fortran variables
  sizeofreal = 8
  dimx = 128
  dimy = 128
  dimz = 256
  chunk_x = 256
  chunk_y = 256
  chunk_z = 256
  is_float = 0
  mode = 1
  quality = 2.6d0
  out_inc_header = 1

  open(unit=iunit, file="density_128x128x256.d64", status='old', access='stream', &
       form='unformatted', action='read', iostat=ios)
  if (ios .ne. 0) then
    write(*,*) "Error opening input file."
    stop
  end if
  allocate(inbuf(dimx*dimy*dimz))
  read(iunit) inbuf(:)
  close(iunit)

  ptr_in = c_loc(inbuf(1))
  bitstream = c_null_ptr
  stream_len = 0
  nthreads = 0

  ierr = sperr_comp_3d(ptr_in, is_float, dimx, dimy, dimz, chunk_x, chunk_y, chunk_z, mode, &
                       quality, nthreads, bitstream, stream_len)
  if (ierr .ne. 0) then
    write(*,*) "C comp function call failed with code", ierr
    stop
  end if
  call c_f_pointer(bitstream, buffer, [stream_len])
  
  open(unit=iunit, file='output.stream', form='unformatted', &
       access='stream', status='replace', action='write', iostat=ios)
  if (ios .ne. 0) then
    write(*,*) "Error opening stream file"
    stop
  end if
  write(iunit) buffer(1:stream_len)
  close(iunit)

  out_dimx=0
  out_dimy=0
  out_dimz=0
  out_is_float = 0

  call sperr_parse_header(bitstream, out_dimx, out_dimy, out_dimz, out_is_float)
  if (out_dimx .ne. dimx .or. out_dimy .ne. dimy .or. out_dimz .ne. dimz .or. out_is_float .ne. is_float) then
    write(*,*) "Parse header wrong"
    stop
  endif 

  ptr_out = c_null_ptr

  ierr = sperr_decomp_3d(bitstream, stream_len, is_float, nthreads, &
                         out_dimx, out_dimy, out_dimz, ptr_out)
  if (ierr .ne. 0) then
    write(*,*) "C decomp function call failed with code", ierr
    stop
  end if
  call c_f_pointer(ptr_out, decomp_array, [out_dimx*out_dimy*out_dimz])

  open(unit=iunit, file='output.data', form='unformatted', &
       access='stream', status='replace', action='write', iostat=ios)
  if (ios /= 0) then
    write(*,*) "Error opening output file"
    stop
  end if
  write(iunit) decomp_array(:)
  close(iunit)

  deallocate(inbuf) ! Deallocate the buffer when done
  call c_free(bitstream)
  call c_free(ptr_out)

end program test_sperr_3d