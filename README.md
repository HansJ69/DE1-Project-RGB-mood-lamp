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


## Lab2: Defining the architecture and simulating components

First, all the inputs are handled by the debouncer blocks. The outputs then go to individual registers incrementing their stored value by one. Theese values are then used as variables for the rainbow_rgb blocks. The output is either enabled or disabled by multiplying the output by the output of a T-Flip-Flop. to reset options to default values a reset signal is sent to all the memory registers.

### Graphical representation of module hierarchy and signal flows.
<img width="1132" height="866" alt="obrazek" src="https://github.com/user-attachments/assets/b5742c68-2677-4b3c-baea-30d618ee1bec" />

### Button debouncer
The debounder module is responsible for debouncing the input signal to be safely used in another modules without accidently registering multiple button presses. It also has a btn_long output for additional functions when holding the button. 
<img width="1302" height="228" alt="debounce_sim" src="https://github.com/user-attachments/assets/0607b6b6-36f7-4567-826a-194d0c341804" />

### PWM modulation
The rainbow_pwm module is responsible for both pwm modulation of all three colour channels and handling the speed and brightness options. In the picture below we can se brightness adjustment of the red channel depending on the desired brightness.
<img width="1712" height="265" alt="pwm_sim" src="https://github.com/user-attachments/assets/cef4eaf8-b528-4a8a-b408-311824e51ff7" />

