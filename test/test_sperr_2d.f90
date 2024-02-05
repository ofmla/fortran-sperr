program test_sperr_2d
  use, intrinsic :: iso_c_binding
  use :: sperr
  implicit none

  integer, parameter :: iunit = 99
  integer(c_int) :: ios, ierr
  integer(c_int) :: is_float, mode, out_inc_header, out_is_float
  real(c_float), allocatable, target :: inbuf(:)
  type(c_ptr) :: ptr_in, bitstream, ptr_start, ptr_out
  real(c_float), pointer :: decomp_array(:)
  character, pointer :: buffer(:)
  real(c_double) :: quality
  integer(c_size_t) :: dimx, dimy, stream_len, out_dimx, out_dimy, out_dimz
  integer(c_intptr_t) :: adda, header_len

  ! Assign values to Fortran variables
  header_len = 10
  dimx = 512
  dimy = 512
  is_float = 1
  mode = 1
  quality = 2.5d0
  out_inc_header = 1

  open(unit=iunit, file="lena512.float", status='old', access='stream', &
       form='unformatted', action='read', iostat=ios)
  if (ios .ne. 0) then
    write(*,*) "Error opening input file."
    stop
  end if
  allocate(inbuf(dimx*dimy))
  read(iunit) inbuf(:)
  close(iunit)

  ptr_in = c_loc(inbuf(1))
  bitstream = c_null_ptr
  stream_len = 0

  ierr = sperr_comp_2d(ptr_in, is_float, dimx, dimy, mode, quality, &
                       out_inc_header, bitstream, stream_len)
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
  if (out_dimx .ne. dimx .or. out_dimy .ne. dimy .or. out_dimz .ne. 1 .or. out_is_float .ne. is_float) then
    write(*,*) "Parse header wrong"
    stop
  endif 

  adda= transfer( source=c_loc(buffer), mold=adda)
  adda= adda + header_len
  ptr_start = transfer(adda, ptr_start)
  ptr_out = c_null_ptr

  ierr = sperr_decomp_2d(ptr_start, stream_len-header_len, is_float, &
                         out_dimx, out_dimy, ptr_out)
  if (ierr .ne. 0) then
    write(*,*) "C decomp function call failed with code", ierr
    stop
  end if
  call c_f_pointer(ptr_out, decomp_array, [out_dimx*out_dimy])

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

end program test_sperr_2d