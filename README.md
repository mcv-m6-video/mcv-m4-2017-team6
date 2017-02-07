## Overview
In this project we propose a video surveillance system which is able to count the amount of vehicles passing by the road and predict its speed. Computer vision systems are cheaper than RADAR based traffic monitoring systems; they require a simpler and cheaper hardware. The main tradeoff is that the algorithm are more complex, thus, the development cycle is longer and the workload is higher. Nowadays, we can find affordable cameras with reliable hardware, therefore, the computer vision algorithms are capable of running in real time eventhough the amount of workload.

## Technology
In order to achive our goals we need to use different techniques such as back substraction, mathematical morphology, video compensation and object tracking.

### Background Substraction
The background substraction is used to segment the cars. We have used a single gaussian adaptative approach in order to model the background. The method has two parameters: alpha, which controls the tolerance of the system, and rho, which provides memory to the model for variable background scenarions.

(foto segmentation)

### Video Compensation
Video compensation plays an important role. Usually the cameras are placed in poles or signs and due to wind or other factors they suffer from vibrations. Having a jittery sequence makes the algorithms less robust; so it is important to process the video to generate a smooth sequence.

To compensate the video we use Optical Flow obtained with the block matching algorithm. The following sequence shows the difference of using video compensation and not using it. In  the two right images we can see the sequence and the sequence of the original video; and in the two left image we have the same sequences using video compensation. We can observe that the segmentation results are better.

<div style="text-align:center"><img src="images/compare_compensation.gif" alt="hi" class="inline"/>

### Object tracking and speed estimation



## Results

## Resources
* [Project Slides](https://docs.google.com/presentation/d/1YJnj8e_IcnCdWf5vRDw2Jt1kaXgdwhmclmG2308rm10/edit#slide=id.g20d2e7dda2_0_134).

* [Project Code](https://github.com/mcv-m4-video/mcv-m4-2017-team6)

* [Project Paper(under construction)]()

* [Dataset](http://www.changedetection.net/)


<img src="images/uno.gif" alt="hi" class="inline"/>
