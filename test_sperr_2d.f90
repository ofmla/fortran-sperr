program test_sperr_2d
  use, intrinsic :: iso_c_binding!, only: c_loc, c_f_pointer, c_intptr_t, c_float, c_null_ptr
  use :: sperr
  implicit none !(type, external)

  !character(len=100) :: filename
  integer(c_int) :: sizeofreal, iunit, ios, ierr
  integer(c_int) :: is_float, mode, out_inc_header, out_is_float
  real(c_float), allocatable, target :: inbuf(:)
  type(c_ptr) :: ptr_in, bitstream, ptr_start, ptr_out
  real(c_float), pointer :: comp_array(:), decomp_array(:)
  real(c_double) :: quality
  integer(c_size_t) :: dimx, dimy, stream_len, out_dimx, out_dimy, out_dimz
  integer(c_intptr_t) :: adda, header_len

  ! Assign values to Fortran variables
  header_len = 10
  sizeofreal = 4
  dimx = 512
  dimy = 512
  is_float = 1
  mode = 1
  quality = 2.5d0
  out_inc_header = 1

  open(unit=iunit, file="lena512.float", status='old', access='stream', &
       form='unformatted', action='read', iostat=ios)
  if (ios .ne. 0) then
    write(*,*) "Error opening file."
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
  end if
  call c_f_pointer(bitstream, comp_array, [stream_len/sizeofreal])
  
  open(unit=iunit, file='output.stream', form='unformatted', &
       access='stream', status='replace', action='write', iostat=ios)
  if (ios .ne. 0) then
    write(*,*) "Error opening file"
    stop
  end if
  write(iunit) comp_array(:)
  close(iunit)

  out_dimx=0
  out_dimy=0
  out_dimz=0
  out_is_float = 0

  call sperr_parse_header(bitstream, out_dimx, out_dimy, out_dimz, out_is_float)  

  adda= transfer( source=c_loc(comp_array), mold=adda)
  adda= adda + header_len
  ptr_start = transfer(adda, ptr_start)
  ptr_out = c_null_ptr

  ierr = sperr_decomp_2d(ptr_start, stream_len-header_len, is_float, &
                         out_dimx, out_dimy, ptr_out)
  if (ierr .ne. 0) then
    write(*,*) "C decomp function call failed with code", ierr
  end if
  call c_f_pointer(ptr_out, decomp_array, [out_dimx*out_dimy])

  open(unit=iunit, file='output.data', form='unformatted', &
       access='stream', status='replace', action='write', iostat=ios)
  if (ios /= 0) then
    write(*,*) "Error opening file"
    stop
  end if
  write(iunit) decomp_array(:)
  close(iunit)

  deallocate(inbuf) ! Deallocate the buffer when done
  call c_free(bitstream)
  call c_free(ptr_out)

end program test_sperr_2d