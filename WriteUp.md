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

[//]: # (Image References)

[image1]: ./examples/undistort_output.png "Undistorted"
[image2]: ./test_images/test1.jpg "Road Transformed"
[image3]: ./examples/binary_combo_example.jpg "Binary Example"
[image4]: ./examples/warped_straight_lines.jpg "Warp Example"
[image5]: ./examples/color_fit_lines.jpg "Fit Visual"
[image6]: ./examples/example_output.jpg "Output"
[video1]: ./project_video.mp4 "Video"

---
## [Rubric](https://review.udacity.com/#!/rubrics/571/view) Points

### Here I will consider the rubric points individually and describe how I addressed each point in my implementation.  

---

### Camera Calibration

#### 1. Briefly state how you computed the camera matrix and distortion coefficients.

Here are the steps I used when calculating the matrix and distortion coefficients for camera calibration.
 
* Prepare a replicated array of coordinates (objp) with specific size (nx = 9, ny = 6) to handle object points
* Prepare the arrays to save image points (imgpoints) & object points (objpoints)
* Apply following processes to each calibration image (calibration\*.jpg)
	- Change image to grayscale
	- Call cv2.findChessboardCorners to find the chessboard corners
	- If it detects the calibration image successfully, add (append) the detected corners as image points together with a copy of "objp" as object points
	- Call cv2.drawChessboardCorners to draw the lines connnecting the detected chessboard corners
	- Save the image with detected corners (in /output_images/ folder)
* Apply camera calibration (by calling cv2.calibrateCamera) with the imgpoints & objpoints taken above to get the matrix (mtx) and distortion coefficients (dist) of the camera
* Save the matrix (mtx) and distortion coefficients (dist) to local file (using pickle) for later use
* Load the saved data (mtx, dist)
 
 *Note:* Doing this can help to avoid running the calibration from the beginning when restarting kernel, etc
* Call cv2.undistort to undistort each image with calibrated data (mtx & dist)
* Save the undistorted images (in /output_images/ folder) 

#### 2. Provide an example of a distortion corrected calibration image.

The output images with detected corners can be found in following path: 

 /output_images/corners_calibration\*.jpg ([link](https://github.com/pl80tech/CarND-Advanced-Lane-Finding/tree/master/output_images)). 

The undistorted images can be found in following path: 

 /output_images/undistorted_calibration\*.jpg ([link](https://github.com/pl80tech/CarND-Advanced-Lane-Finding/tree/master/output_images)). 

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

I used a combination of color and gradient thresholds to generate a binary image (thresholding steps at lines # through # in `another_file.py`).  Here's an example of my output for this step.  (note: this is not actually from one of the test images)

![alt text][image3]

#### 3. Describe how (and identify where in your code) you performed a perspective transform and provide an example of a transformed image.

The code for my perspective transform includes a function called `warper()`, which appears in lines 1 through 8 in the file `example.py` (output_images/examples/example.py) (or, for example, in the 3rd code cell of the IPython notebook).  The `warper()` function takes as inputs an image (`img`), as well as source (`src`) and destination (`dst`) points.  I chose the hardcode the source and destination points in the following manner:

```python
src = np.float32(
    [[(img_size[0] / 2) - 55, img_size[1] / 2 + 100],
    [((img_size[0] / 6) - 10), img_size[1]],
    [(img_size[0] * 5 / 6) + 60, img_size[1]],
    [(img_size[0] / 2 + 55), img_size[1] / 2 + 100]])
dst = np.float32(
    [[(img_size[0] / 4), 0],
    [(img_size[0] / 4), img_size[1]],
    [(img_size[0] * 3 / 4), img_size[1]],
    [(img_size[0] * 3 / 4), 0]])
```

This resulted in the following source and destination points:

| Source        | Destination   | 
|:-------------:|:-------------:| 
| 585, 460      | 320, 0        | 
| 203, 720      | 320, 720      |
| 1127, 720     | 960, 720      |
| 695, 460      | 960, 0        |

I verified that my perspective transform was working as expected by drawing the `src` and `dst` points onto a test image and its warped counterpart to verify that the lines appear parallel in the warped image.

![alt text][image4]

#### 4. Describe how (and identify where in your code) you identified lane-line pixels and fit their positions with a polynomial?

Then I did some other stuff and fit my lane lines with a 2nd order polynomial kinda like this:

![alt text][image5]

#### 5. Describe how (and identify where in your code) you calculated the radius of curvature of the lane and the position of the vehicle with respect to center.

I did this in lines # through # in my code in `my_other_file.py`

#### 6. Provide an example image of your result plotted back down onto the road such that the lane area is identified clearly.

I implemented this step in lines # through # in my code in `yet_another_file.py` in the function `map_lane()`.  Here is an example of my result on a test image:

![alt text][image6]

---

### Pipeline (video)

#### 1. Provide a link to your final video output.  Your pipeline should perform reasonably well on the entire project video (wobbly lines are ok but no catastrophic failures that would cause the car to drive off the road!).

Here's a [link to my video result](./project_video.mp4)

---

### Discussion

#### 1. Briefly discuss any problems / issues you faced in your implementation of this project.  Where will your pipeline likely fail?  What could you do to make it more robust?

Here I'll talk about the approach I took, what techniques I used, what worked and why, where the pipeline might fail and how I might improve it if I were going to pursue this project further.  
