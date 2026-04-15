# RGB Mood lamp

## Team Members

- Jan Pikner (270868)
- Josef Cvejn (270573)

## main goal
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
