##  Mikrotik CCR2004 configuration factory reset

1) Disconnect power from the router

2) Press and hold reset button

3) Connect power to the router AND with the reset button still pressed watch the 'USER' LED light

* After 4-5 seconds the 'USER' LED is solid green - note but ignore this!
* After another 8-9 seconds (12-13 seconds since power on) the 'USER' LED starts to flash green - release the reset button at this point for a 
  factory reset of the configuration

Note that if after 18 seconds since power on the USER LED is now showing solid green again AND the reset button is now released the router will be 
operating in CAPSMAN mode and will not be pingable on 192.168.88.1 as the interfaces are slaved - so try again!
