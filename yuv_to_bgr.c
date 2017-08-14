/*************************************************************************
* File Name           : YUV_to_BGR.c
* Description         : Function to COnvert the output from YUV420 to BGR24
*************************************************************************/

/*To make sure that you are bounding your inputs in the range of 0 & 255*/
#define SATURATE8(x) ((unsigned int) x <= 255 ? x : (x < 0 ? 0: 255))



/*************************************************************************
* Function Name             : Convert_yuv420_to_bgr24
* Description               : Converts YUV420 to BGR24 format
* Return Value              : none
*************************************************************************/
Void Convert_yuv420_to_bgr24(char *videoBuffer, char * buffer_rgb, unsigned int Height, unsigned int Width)
{
  char  *buffer_rgb_1strow, *buffer_rgb_2ndrow;
  unsigned char y_start, u_start, v_start;

  unsigned int * videoBuffer_1strow,*videoBuffer_2ndrow;
  int r,g,b, r_prod, g_prod, b_prod;
  int  y,u,v;

  unsigned int i_conv_ht =0,i_conv_wt =0;
  unsigned int y_size;

  char * cb_ptr;
  char * cr_ptr;


  /*Now do the conversion from YUV420  to BGR 888 */
  /*So allocate that many amount of buffer*/
  /*allocate memory to contain the one frame for RGB output:*/

  /*Now do the conversion from YUV420  to BGR 888 */
  /*So allocate that many amount of buffer*/
  /*We are planning to convert an YUV file to RGB file*/

  y_size = Width*Height;
  
  /*Calculate the Cb & Cr pointer*/
  cb_ptr = videoBuffer + y_size;
  cr_ptr = cb_ptr + y_size/4;

  videoBuffer_1strow = videoBuffer;
  videoBuffer_2ndrow = videoBuffer+Width;

  buffer_rgb_1strow = buffer_rgb ;
  buffer_rgb_2ndrow = buffer_rgb+(3*Width);

  for (i_conv_ht =0; i_conv_ht<Height;i_conv_ht+=2)
  {
        for (i_conv_wt =0; i_conv_wt<Width;i_conv_wt+=2)

            {
               /*For a YUV 420 data with width & height is 4x6*/
               /*Following is the pattern it was stored*/
               /*Y1  Y2  Y3  Y4  Y5  Y6*/
               /*Y7  Y8  Y9  Y10 Y11 Y12*/
               /*Y13 Y14 Y15 Y16 Y17 Y18*/
               /*Y19 Y20 Y21 Y22 Y23 Y24*/
               /*U1  U2  U3  U4  U5  U6*/
               /*V1  V2  V3  V4  V5  V6*/
               /*Please note Y1 Y2 Y7 Y8 will be sharing U1 and V1*/
               /*&*/
               /*Y3 Y4 Y9 Y10 will be sharing U2 V2*/
               /*Following is the plan*/
               /*We know that Y1 & Y2 is going to pair with the first U (say U1) & V (say V1) */
               /*That means trigger the movement of cb & cr pointer*/
               /*only for 2 y movement*/

               /*Extract the Y value*/

                y_start = *videoBuffer_1strow++;
                y = (y_start -16)*298;

                /*extract  the value*/
                u_start = *cb_ptr++;
                v_start = *cr_ptr++;

               /*precalculate it*/
                u = u_start - 128;
                v = v_start - 128;

                r_prod = 409*v + 128;
                g_prod = 100*u + 208*v - 128;
                b_prod = 516*u;

                /*!!! now it is time to do the conversion*/
                r =(y + r_prod)>>8;
                g =(y - g_prod)>>8;
                b =(y + b_prod)>>8;

                /*Now clip and store */
                *buffer_rgb_1strow++ = SATURATE8(b);
                *buffer_rgb_1strow++ = SATURATE8(g);
                *buffer_rgb_1strow++ = SATURATE8(r);

                /*Extract the Y value*/
                y_start = *videoBuffer_1strow++;
                y = (y_start -16)*298;

                /*!!! now it is time to do the conversion*/
                r =(y + r_prod)>>8;
                g =(y - g_prod)>>8;
                b =(y + b_prod)>>8;

                /*Now clip and store */

                *buffer_rgb_1strow++ = SATURATE8(b);
                *buffer_rgb_1strow++ = SATURATE8(g);
                *buffer_rgb_1strow++ = SATURATE8(r);

                /*Extract the Y value*/
                y_start = *videoBuffer_2ndrow++;
                y = (y_start -16)*298;

                /*!!! now it is time to do the conversion*/
                r =(y + r_prod)>>8;
                g =(y - g_prod)>>8;
                b =(y + b_prod)>>8;

                /*Now clip and store */
                *buffer_rgb_2ndrow++ = SATURATE8(b);
                *buffer_rgb_2ndrow++ = SATURATE8(g);
                *buffer_rgb_2ndrow++ = SATURATE8(r);

                /*Extract the Y value*/
                y_start = *videoBuffer_2ndrow++;
                y = (y_start -16)*298;

                /*!!! now it is time to do the conversion*/
                r =(y + r_prod)>>8;
                g =(y - g_prod)>>8;
                b =(y + b_prod)>>8;


                /*Now clip and store */
                *buffer_rgb_2ndrow++ = SATURATE8(b);
                *buffer_rgb_2ndrow++ = SATURATE8(g);
                *buffer_rgb_2ndrow++ = SATURATE8(r);
            }
            videoBuffer_1strow += Width;
            videoBuffer_2ndrow += Width;

            buffer_rgb_1strow += 3*Width;
            buffer_rgb_2ndrow += 3*Width;
         }
    }




