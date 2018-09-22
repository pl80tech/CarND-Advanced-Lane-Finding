# Writeup

This is my writeup for the project "Advanced Lane Finding" of Self Driving Car Nanadegree on Udacity.

---

**Advanced Lane Finding Project**

The goals / steps of this project are the following:

* Compute the camera calibration matrix and distortion coefficients given a set of chessboard images.
* Apply a distortion correction to raw images.
* Use color transforms, gradients, etc., to create a thresholded binary image.
* Apply a perspective transform to rectify binary image ("birds-eye view").
* Detect lane pixels and fit to find the lane boundary.
* Determine the curvature of the lane and vehicle position with respect to center.
* Warp the detected lane boundaries back onto the original image.
* Output visual display of the lane boundaries and numerical estimation of lane curvature and vehicle position.

---
## Project code

Here is my working repository for this project:

https://github.com/pl80tech/CarND-Advanced-Lane-Finding

It is imported from below original repository:

https://github.com/udacity/CarND-Advanced-Lane-Finding

---
### Note

In this writeup, some output videos are embedded for demonstratation and explanation. However, video can't be displayed in markdown file when viewing on GitHub due to no support.

To view these embedded videos, please open this file locally in browser (with markdown viewer support). These videos can also be found in "output_videos" folder.

---
## [Rubric](https://review.udacity.com/#!/rubrics/571/view) Points

### Here I will consider the rubric points individually and describe how I addressed each point in my implementation.  

---

### Camera Calibration

#### 1. Briefly state how you computed the camera matrix and distortion coefficients.

Here are the steps I used when calculating the matrix and distortion coefficients for camera calibration.
 
* Prepare a replicated array of coordinates (*objp*) with specific size (*nx = 9, ny = 6*) to handle object points
* Prepare the arrays to save image points (*imgpoints*) & object points (*objpoints*)
* Apply following processes to each calibration image (calibration\*.jpg)
	- Change image to grayscale
	- Call *cv2.findChessboardCorners* to find the chessboard corners
	- If it detects the calibration image successfully, add (append) the detected corners as image points together with a copy of "*objp*" as object points
	- Call *cv2.drawChessboardCorners* to draw the lines connnecting the detected chessboard corners
	- Save the image with detected corners (in */output_images/* folder)
* Apply camera calibration (by calling *cv2.calibrateCamera*) with the imgpoints & objpoints taken above to get the matrix (*mtx*) and distortion coefficients (*dist*) of the camera
* Save the matrix (*mtx*) and distortion coefficients (*dist*) to local file (using pickle) for later use
* Load the saved data (*mtx*, *dist*)
	- *Note:* Doing this can help to avoid running the calibration from the beginning when restarting kernel, etc
* Call *cv2.undistort* to undistort each image with calibrated data (*mtx* & *dist*)
* Save the undistorted images (in */output_images/* folder) 

#### 2. Provide an example of a distortion corrected calibration image.

The output images with detected corners and undistorted images are saved in following path: 

* /output_images/corners_calibration\*.jpg ([link](https://github.com/pl80tech/CarND-Advanced-Lane-Finding/tree/master/output_images)). 

* /output_images/undistorted_calibration\*.jpg ([link](https://github.com/pl80tech/CarND-Advanced-Lane-Finding/tree/master/output_images)). 

Here are some examples of the undistorted image, showing together with its original image & image with detected corners for easy comparison:

* calibration2.jpg (Original image, Image with detected corners, Undistorted image)

	<img src="camera_cal/calibration2.jpg" width="280" title="calibration2.jpg"/>
	<img src="output_images/corners_calibration2.jpg" width="280" title="calibration2.jpg - with corners"/>
	<img src="output_images/undistorted_calibration2.jpg" width="280" title="calibration2.jpg - undistorted"/>

* calibration3.jpg (Original image, Image with detected corners, Undistorted image)

	<img src="camera_cal/calibration3.jpg" width="280" title="calibration3.jpg"/>
	<img src="output_images/corners_calibration3.jpg" width="280" title="calibration3.jpg - with corners"/>
	<img src="output_images/undistorted_calibration3.jpg" width="280" title="calibration3.jpg - undistorted"/>

* calibration6.jpg (Original image, Image with detected corners, Undistorted image)

	<img src="camera_cal/calibration6.jpg" width="280" title="calibration3.jpg"/>
	<img src="output_images/corners_calibration6.jpg" width="280" title="calibration6.jpg - with corners"/>
	<img src="output_images/undistorted_calibration6.jpg" width="280" title="calibration6.jpg - undistorted"/>

### Pipeline (single images)

#### 1. Provide an example of a distortion-corrected image.

Here are the example results after applying the distortion-corrected process mentioned above to the raw images in "/test_images/" folder:

* test1.jpg (Original image & Undistorted image)

	<img src="test_images/test1.jpg" width="420" title="test1.jpg - original"/>
	<img src="output_images/undistorted_test1.jpg" width="420" title="test1.jpg - undistorted"/>

* straight_lines1.jpg (Original image & Undistorted image)

	<img src="test_images/straight_lines1.jpg" width="420" title="straight_lines1.jpg - original"/>
	<img src="output_images/undistorted_straight_lines1.jpg" width="420" title="straight_lines1.jpg - undistorted"/>

*Note:* All undistorted output images can be found in following paths: 

* /output_images/undistorted_test\*.jpg ([link](https://github.com/pl80tech/CarND-Advanced-Lane-Finding/tree/master/output_images)).
 
* /output_images/undistorted_straight\*.jpg ([link](https://github.com/pl80tech/CarND-Advanced-Lane-Finding/tree/master/output_images)).

#### 2. Describe how (and identify where in your code) you used color transforms, gradients or other methods to create a thresholded binary image.  Provide an example of a binary image result.

I implemented below helper functions to generate a binary image with various thresholds of color & gradient:

* *abs_sobel_thresh()*: create a binary image with the given sobel kernel size and threshold values of gradient (on x & y orientation)
* *mag_thresh()*: create a binary image with the given sobel kernel size and threshold values of gradient magnitude
* *dir_threshold()*: create a binary image with the given sobel kernel size and threshold values of gradient direction
* *color_thresh()*: create a binary image with a given range of color
* *hls_select()*: create a binary image with the threshold of S-channel on HLS
* *combined_thresh()*: create a binary image by combining several thresholds

To easily select thresholding method for processing & tuning image/video, I implemented *thresh_binary()* which can call below methods by specifying *threshold_method*:

* *threshold_method* = 1 => color threshold 
* *threshold_method* = 2 => S-Channel (HLS) threshold
* *threshold_method* = 3 => combined threshold

Here are the output images with some combinations of gradient & color threshold:

* test1.jpg

	<img src="test_images/test1.jpg" width="210" title="test1.jpg"/>
	<img src="output_binary_images/gradx_test1.jpg" width="210" title="test1.jpg - gradient x"/>
	<img src="output_binary_images/grady_test1.jpg" width="210" title="test1.jpg - gradient y"/>
	<img src="output_binary_images/mag_test1.jpg" width="210" title="test1.jpg - magnitude"/>

	<img src="output_binary_images/dir_test1.jpg" width="210" title="test1.jpg - direction"/>
	<img src="output_binary_images/color_test1.jpg" width="210" title="test1.jpg - color"/>
	<img src="output_binary_images/hls_test1.jpg" width="210" title="test1.jpg - HLS S-channel"/>
	<img src="output_binary_images/combined_test1.jpg" width="210" title="test1.jpg - combined"/>			

* test2.jpg

	<img src="test_images/test2.jpg" width="210" title="test1.jpg"/>
	<img src="output_binary_images/gradx_test2.jpg" width="210" title="test2.jpg - gradx"/>
	<img src="output_binary_images/grady_test2.jpg" width="210" title="test2.jpg - grady"/>
	<img src="output_binary_images/mag_test2.jpg" width="210" title="test2.jpg - magnitude"/>

	<img src="output_binary_images/dir_test2.jpg" width="210" title="test2.jpg - direction"/>
	<img src="output_binary_images/color_test2.jpg" width="210" title="test2.jpg - color"/>
	<img src="output_binary_images/hls_test2.jpg" width="210" title="test2.jpg - HLS S-channel"/>
	<img src="output_binary_images/combined_test2.jpg" width="210" title="test2.jpg - combined"/>

* Others:

	All thresholded binary image (generated from test images) are shown in ThresholdedImage.md ([link](https://github.com/pl80tech/CarND-Advanced-Lane-Finding/blob/master/ThresholdedImage.md))

#### 3. Describe how (and identify where in your code) you performed a perspective transform and provide an example of a transformed image.

Here are the steps I used in my implementation:

* Choose the hard-coded source (src) and destination (dst) points as follows:
	- 
	- 
* Pass src & dst together with targeted binary image (img) to function warped()
* Inside warped():
	- Call cv2.getPerspectiveTransform(src, dst) to calculate the transform matrix (M) with given src & dst
	- Call cv2.warpPerspective to execute perpective transform with the calculated matrix (M)

Here are some examples of transformed image:

* test1.jpg

	<img src="output_images/undistorted_test1.jpg" width="400" title="Original"/>
	<img src="output_images/warped_test1.jpg" width="400" title="Perspective transform"/>

* test2.jpg

	<img src="output_images/undistorted_test2.jpg" width="400" title="Original"/>
	<img src="output_images/warped_test2.jpg" width="400" title="Perspective transform"/>

* straight_lines1.jpg

	<img src="output_images/undistorted_straight_lines1.jpg" width="400" title="Original"/>
	<img src="output_images/warped_straight_lines1.jpg" width="400" title="Combined thesholded"/>

#### 4. Describe how (and identify where in your code) you identified lane-line pixels and fit their positions with a polynomial?


#### 5. Describe how (and identify where in your code) you calculated the radius of curvature of the lane and the position of the vehicle with respect to center.

Here are the main steps I used to calculate the curvature information.

* Define conversion rate in x and y from pixels space to meters
* Change the given lane coordinates (*ploty, left_fitx, right_fitx* - simulated in previous step) in pixel space to meter space
* Pass the new coordinates (in meter space) to *np.polyfit()* to fit second order polynomials for left & right line
* Use the mathematic equation defined in [link](https://www.intmath.com/applications-differentiation/8-radius-curvature.php) to calculate the left & right curvature radius (*left_curverad*, *right_curverad*) of the lane points whose y-value are correspondent to the bottom of the image.
* Take the average of *left_curverad* & *right_curverad* as final radius of curvature 
* Calculate the position of left line & right lane nearest to the camera then take the average as the center of the 2 lanes (*position*)
* Calculate the distance from center of the lane (*position*) to center of the image. 

The details are implemented with comments for each process in below functions on the project file ([link](https://github.com/pl80tech/CarND-Advanced-Lane-Finding/blob/master/P2-AdvancedLaneFinding.ipynb)):

* *measure_curvature_radius_position()*: calculate radius of curvature & the relative position (distance from center) from simulated lane coordinates
* *add_radius_distance()*: combine the calculated information to the image being processed

#### 6. Provide an example image of your result plotted back down onto the road such that the lane area is identified clearly.

Here is an example of the image with detected lane lines & curvature information:

<img src="output_images/test1_curvature_info.jpg" width="640" title="test1.jpg - final result"/>

---

### Pipeline (video)

#### 1. Provide a link to your final video output.  Your pipeline should perform reasonably well on the entire project video (wobbly lines are ok but no catastrophic failures that would cause the car to drive off the road!).

Here is my final output from project video, which is generated by using thresholding method 2 (based on color) & searching method 2 (based on prior frame):

  <figure class="video_container">
    <video controls="true" allowfullscreen="true" width="640" title="Final output from project video file">
      <source src="output_videos/project_video_output.mp4" type="video/mp4">
    </video>
  </figure>

  (*Path to the video:* /output_videos/project_video_output.mp4 : [link](https://github.com/pl80tech/CarND-Advanced-Lane-Finding/blob/master/output_videos/project_video_output.mp4))

---

### Discussion

#### 1. Briefly discuss any problems / issues you faced in your implementation of this project.  Where will your pipeline likely fail?  What could you do to make it more robust?
