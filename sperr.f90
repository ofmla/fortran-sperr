module sperr
    use, intrinsic :: iso_c_binding
    implicit none !(type, external)
    private

    public :: sperr_comp_2d
    public :: sperr_parse_header
    public :: sperr_decomp_2d
    public :: sperr_comp_3d
    public :: sperr_decomp_3d
    public :: c_free

  ! Declare the C function prototype
    interface
    function sperr_comp_2d(src, is_float, dimx, dimy, mode, quality, &
                           out_inc_header, dst, dst_len) bind(c, name="sperr_comp_2d")
      import :: c_int, c_size_t, c_double, c_ptr
      implicit none
      type(c_ptr), value :: src
      integer(c_int), value :: is_float
      integer(c_size_t), value :: dimx, dimy
      integer(c_int), value :: mode
      real(c_double), value :: quality
      integer(c_int), value :: out_inc_header
      type(c_ptr) :: dst
      integer(c_size_t) :: dst_len
      integer(c_int) :: sperr_comp_2d
    end function sperr_comp_2d

    subroutine sperr_parse_header(src, dimx, dimy, dimz, is_float) bind(c, name="sperr_parse_header")
      import :: c_int, c_size_t, c_ptr
      implicit none
      type(c_ptr), value :: src
      integer(c_size_t), intent(out) :: dimx, dimy, dimz
      integer(c_int), intent(out) :: is_float
    end subroutine sperr_parse_header

    function sperr_decomp_2d(src, src_len, output_float, dimx, dimy, dst) bind(c, name="sperr_decomp_2d")
      import :: c_int, c_size_t, c_ptr
      implicit none
      type(c_ptr), value :: src
      integer(c_size_t), value :: src_len
      integer(c_int), value :: output_float
      integer(c_size_t), value :: dimx, dimy
      type(c_ptr) :: dst
      integer(c_int) :: sperr_decomp_2d
    end function sperr_decomp_2d

    function sperr_comp_3d(src, is_float, dimx, dimy, dimz, &
                           chunk_x, chunk_y, chunk_z, mode, &
                           quality, nthreads, dst, dst_len) bind(c, name="sperr_comp_3d")
      import :: c_int, c_size_t, c_double, c_ptr
      implicit none
      type(c_ptr), value :: src
      integer(c_int), value :: is_float
      integer(c_size_t), value :: dimx, dimy, dimz, chunk_x, chunk_y, chunk_z
      integer(c_int), value :: mode
      real(c_double), value :: quality
      integer(c_size_t), value :: nthreads
      type(c_ptr) :: dst
      integer(c_size_t) :: dst_len
      integer(c_int) :: sperr_comp_3d
    end function

    function sperr_decomp_3d(src, src_len, output_float, nthreads, &
                             dimx, dimy, dimz, dst) bind(c,name="sperr_decomp_3d")
      import :: c_int, c_size_t, c_ptr
      implicit none
      type(c_ptr), value :: src
      integer(c_size_t), value :: src_len
      integer(c_int), value :: output_float, nthreads
      integer(c_size_t) :: dimx, dimy, dimz
      type(c_ptr) :: dst
      integer(c_int) :: sperr_decomp_3d
    end function

    subroutine c_free(ptr) bind(c, name="free")
      import :: c_ptr
      implicit none
      type(c_ptr), value :: ptr
    end subroutine c_free
    end interface
end module sperr