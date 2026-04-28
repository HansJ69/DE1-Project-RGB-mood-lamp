# RGB Mood lamp

## Team Members

- Jan Pikner (270868)
- Josef Cvejn (270573)

## Main goal
Develop and implement RGB LED control for the Nexys A7-50T FPGA development board

The user will be able to control the following settings:
- Control brightness of both LEDs indivudually
- Cange speed of the rainbow effect
- Turn individual LEDs on or off
- Reset to default parameters anytime

## Lab1: Defining architecture and functionality

### Assigning button functions

| Button | Press | Function |
| :--- | :--- | :--- |
| btnu | Short | Cycle brightness of left LED |
| btnd | Short | Cycle brightness of right LED |
| btnl | Short | Cycle effect speed of left LED |
| btnr | Short | Cycle effect speed of right LED |
| btnl | Long | Turn left LED on or off |
| btnr | Long | Turn right LED on or off |
| btnc | Short | Reset all parameters to default |

### Graphical representation of module hierarchy and signal flows.
<img width="1132" height="866" alt="obrazek" src="https://github.com/user-attachments/assets/b5742c68-2677-4b3c-baea-30d618ee1bec" />

First, all the inputs are handled by the debouncer blocks. The outputs then go to individual registers incrementing their stored value by one. Theese values are then used as variables for the rainbow_rgb blocks. The output is either enabled or disabled by multiplying the output by the output of a T-Flip-Flop. to reset options to default values a reset signal is sent to all the memory registers.

## Lab2: Designing and simulating components

### Button debouncer
The debounder module is responsible for debouncing the input signal to be safely used in another modules without accidently registering multiple button presses. It also has a btn_long output for additional functions when holding the button. 
<img width="1302" height="228" alt="debounce_sim" src="https://github.com/user-attachments/assets/0607b6b6-36f7-4567-826a-194d0c341804" />

### PWM modulation
The rainbow_pwm module is responsible for both pwm modulation of all three colour channels and handling the speed and brightness options. In the picture below we can see the module output when setting brightness at 25%, 50%, and 100% while being slowed down.

**[Open tb_debounce.vhd](/Project%20files/project_incident/project_incident.srcs/sim_1/new/tb_debounce.vhd)**
<img width="1325" height="571" alt="obrazek" src="https://github.com/user-attachments/assets/541170bc-f1a8-46cd-bdfd-2d004f6f1952" />
In the picture below we can see a closeup of brightness adjustment of the red channel depending on the desired brightness. other channels are not active in this early stage yet as it takes about 280ms to start ramping up.

**[Open tb_rainbow_pwm.vhd](/Project%20files/project_incident/project_incident.srcs/sim_1/new/tb_rainbow_pwm.vhd)**
<img width="1712" height="265" alt="pwm_sim" src="https://github.com/user-attachments/assets/cef4eaf8-b528-4a8a-b408-311824e51ff7" />
Here is a closeup of the simulation above to see the PWM modulation change at 2ms:
<img width="1054" height="825" alt="obrazek" src="https://github.com/user-attachments/assets/315d4bcc-c02b-49a8-9525-6a9fee5cf4cf" />

## Lab3: Merging modules into the Top-level entity
The top module serves as the primary integration layer. It connects the hardware constraints (100MHz clock, active-low CPU reset) to five individual debounce instances. The processed signals drive the synchronous logic that maintains the current state (speed, brightness, and enable flags) for both sides. These states are then routed directly into the rainbow_pwm instances.


**[Open tb_top.vhd](/Project%20files/project_incident/project_incident.srcs/sim_1/new/tb_top.vhd)**
