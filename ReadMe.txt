V0090 update.
We merged remote configuration part with rick's new design(V008_2), and the changes are as follow:
  (1)  GOLD firmware has no housekeeping data send out by having a macro definition--#define GOLD_COPY;
  (2)  IP address is not from J3 on quabo, but from mobo jumpers;
  (3)  netmask is changed to 255.255.252.0 (That's a right netmask, which can cover 192.168.0.0--192.168.3.255);
        [Notice: The netmask on your computer should also be changed to 255.255.252.0]
  (4)  mac address is from flash chip uid(first 6 bytes are set to mac address);
  (5)  xdc file is changed to make sure IP address is from jumpers on mobo;
