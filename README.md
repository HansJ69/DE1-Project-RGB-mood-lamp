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


## Lab2: Simulating components

### Graphical representation of module hierarchy and signal flows.
<img width="1131" height="863" alt="obrazek" src="https://github.com/user-attachments/assets/5fa2ab95-389d-4beb-95c5-2e10d0e2e750" />

### Button debouncer
<img width="1302" height="228" alt="debounce_sim" src="https://github.com/user-attachments/assets/0607b6b6-36f7-4567-826a-194d0c341804" />

### PWM modulation
<img width="1712" height="265" alt="pwm_sim" src="https://github.com/user-attachments/assets/cef4eaf8-b528-4a8a-b408-311824e51ff7" />

