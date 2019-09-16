# 3DSensorimotorObstacleAvoidance

Final Project, University of Bristol, MSc Robotics



## Requirements

-  compare how my work different from others (better/worse)
- evaluation methods (ask supervisor)
- discuss methods, valid? contribute something
- know the methodology is the main point of this unit, don’t be afraid of no contribution.
- deadline: 19/09/2019 14:00
- PDF version
- append ethical checklist to paper
- marking results come out in a month



## Introduction

- In this paper, we propose that the Interaural Intensity Difference (**IID**) and travel time of the **first millisecond of the echo train** are sufficient cues for obstacle avoidance.
- Rhinolophidae (long narrow band signal) **—>** other bats (short broad band signal)
- The characteristic **cyclical pinna movements** shown by Rhinolophidae [11, 12] have been suggested to compensate for the lack of spatial cues available to bats relying on broadband calls.
- Moving ears generate changing IIDs encoding the reflector position in both the horizontal and the vertical plane.
- Hence, while it has been shown that pinnae movements play a significant role in obstacle avoidance [3], it is still not clear what information Rhinolophidae extract from such pinna movements to allow them to avoid natural (and complex) obstacles.
- In particular, we propose a sensorimotor system that does not rely on the bat reconstructing the 3D spatial layout of reflectors from the echoes, but instead relies on the dynamics of the bat-obstacle interaction to result in obstacle avoidance behaviour.
- It uses IID and time delay of the first echo onset in combination with alternating pinna movements to guide the bat. In particular, it processes only the first millisecond of the echo train.



## Method

The intensity **g i** (in dB) of the echo received from reflector i:

![gi](notes-image/gi.png)

**g<sub>bat</sub>** = intensity of the call at 10 cm from the mouth 120 dBspl

**r<sub>i</sub>** = range to reflector i

**a<sub>f</sub>** = atmospheric absorption at frequency f

**d** <sub>**ϕ** **i ,p**</sub> = directional sensitivity of the sonar apparatus of the bat for angle ϕ i and pinnae position p

**s<sub>i</sub>** = echo strength of the reflector respectively (物体吸收声音)

**ϕ** <sub>**i**</sub> = heading direction ϕ i of reflector i

~~**c** <sub>**ϕ** **i**</sub> = denotes an additional attenuation reflecting changes in cochlear sensitivity for different frequencies~~

![gt](notes-image/gt.png)

**ϕ i,t** is a random phase angle (between −π and π) modeling the interference between narrowband echoes. Note that this phase angle is randomized independently for each reﬂector i and ear t.

The echoes received at each ear t during the first millisecond after the arrival of the first echo are summed with randomized phase shifts.

![{\displaystyle e^{ix}=\cos x+i\sin x,}](https://wikimedia.org/api/rest_v1/media/math/render/svg/aab1fcd1a6db5cc6678bb9cbd871580eeeb86eda)

​              



## Task Log

### Week 1

#### 24/06

- Can I get any example code? / tutorial?  

  - How the bat interacts with the artificial environments?

- Echoes from all reflectors/obstacles need to be calculated?

- Which elements make the intensity between ears (totally 4) different? (d øi,p ?)

- How is gravity affects bat? 

- Do I need to report any progress?



#### 25/06

- ~~find specific directivity of MA40S4R MA40E7R~~
- ~~define temperature and humidity~~ 



#### 26/06

- ~~define temperature and humidity —> af~~
- ~~try to build a simple model and a timeline with small amount of obstacles~~
- ~~try to determine g<sub>t</sub>~~ 
- set threhold in matrix / echoes from back set to 0 dB



#### 28/06

- ~~try to determine g<sub>t</sub>~~
- A static model has been built, then is to build a dynamic model / make it move

### Week 2

#### 04/07

- modified existing code —> able to run
- Next:
  - ~~write makeWorld();~~
  - simulate in 3D space
  - add gravity / limitation of 
  - add target search 

### Week 3

#### 08/07

- Code decription:
  1. Create an environment —> R
  2. Set iteration times / replication times 
  3. For each ear, **gi** is calculated and filtered (gi for ears are independent)
  4. **gt** is calculated after then
  5. Velocity is determined by the distance to the closest reflector(filtered)
  6. Rotate world and calculate bat's position
- add target search
  - First attempt: 
    1. Compare **current_az** vector and **target** vector —> delta theta; 
    2. Add delta theta to current_az;

#### 09/07

Second attempt:

1. When the closest distance is bigger than 0.034, control the bat flying towards the target;

- Test it in 3d;
- Build more complicated environment;

#### 10/07

- Find a minimum distance for all situation
  - If the minimum value is too small, then there is not enough room for the bat to turn around, so if we want the bat to avoid a large cluster of reflectors, the minimum value should set higher, which gives the bat enough room to slow down and turn a bigger angle and then able to avoid clusters correctly.
  - However, when the minimum value is big, it will not able to perform target search properly in dense habitats. The dense simulation must be abandened in this way.
- See how angular velocity effects oscillations

#### 11/07

- Minimum distance (0.3m, 0.4m)
  - Due to the random phase angle, it sometimes hit the wall, why we need this random phase angle, what does it do?
  - It can cause error, the order of gt can be changed because of this.

> **ϕ i,t** is a random phase angle (between −π and π) modeling the interference between narrowband echoes. Note that this phase angle is randomized independently for each reﬂector i and ear t.

- Next step:
  - Add handness 
  - Show how angular velocity affects oscillations

#### 12/07

- Minimum speed has been set to 0m/s
- Minimum distance to perform obstacle avoidance is set to 0.4m
- Reduce randomness? 

### Skype Meeting 

- How to reduce randomness
  - constrain the reflector strength / random phase angle
- Do you have a down direction component yet?
  If not, think about a component implementing a preference for level flight and perhaps a preferred height. 
- Turn around when closer than 0.1 m.
  - Not possible, unless increase angular velocity when turn
- Evaluate a longer time window.
- Take out / reduce any random components and see what happens.
- I don't understand how a random walk can occur in the interplay of a global attraction and local information... Perhaps this is what one needs to focus on.
- Your aim should be to reduce randomness in the trajectories.

### Week 4

#### 16/07

- Elevation problem
  - When seperating elevation and azimuth, I did the same experiments (2d ring) setting one of them to 0 respectively, the results seemed to be correct.
  - The problem might be the way I combined them?

#### 17/07

- 

### Week 5

#### 22/07

- Find out a good way to solve the elevation problem

#### 25/07

Tasks:

- Prefered fly height —> y 
- Limited elevation angle —>?