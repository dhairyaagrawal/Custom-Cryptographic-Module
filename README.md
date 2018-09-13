<h1 align="center">Custom Cryptographic Module</h1>
<p align="center">
  <b>A specialized ASIC to rapidly compute AES-128.</b><br>
</p>

<p align="center">
    <img src="https://lh3.googleusercontent.com/ySeIDGiyt16lE3YcWlBovOwys95JmM7jOcYWc7HdXuysO0bFb_nhStyq9ehvhKJbmQ3y3AlRJr0yTWjcFlK27jkPJtyqnhBGNiVENIMTIIB9BaVjaBHXjhxpq0MLY14WxWlDtojzGuk" alt="Master Private Key Embedded" width="400"/>
</p>

## What is this?

This repository conatins verilog code for a Custom Cryptographic module.  When Synthesized, this ASIC is capable of encrypting data sent to it over an AHB-lite bus with AES-128. The device comes embedded with a Master Private Key that never leaves the ASIC. The MPK is used to encrypt the auxiliary key used to encrypt the data after the encryption is complete. This allows for the auxiliary key used in the encryption to be stored outside of the device and makes it so that this device is the only thing capable of decrypting the data.

## **NOTE

Some of the build scripts and synthesis files for this project were written by Purdue University and are currently proprietary information. All functionality and design for the processor is posted here and was written by myself and my team.

## Built With

* [Verilog/System Verilog](http://www.verilog.com/) - Used to generate the circuit layout.


## Authors

* **Ryan Devlin** - *Design and testing* - [RyanDevlin](https://github.com/RyanDevlin)
* **Dhairya Agrawal** - *Design and testings* - [DhairyaAgrawal](https://github.com/RyanDevlin)
* **Samuale Yigrem** - *Design and testing* - [SamualeYigrem](https://github.com/syigrem)
* **Samanth Mottera** - *Design and testing* - [SamanthMottera](https://github.com/smottera)
## License

This project is licensed under the MIT License - see the [LICENSE.md](https://github.com/PurdueCAM2Project/CamMobile/blob/master/LICENSE) file for details

## Acknowledgments

* Thanks to Dr. Mark Johnson for organizing this project.
* Thanks to Tim Prichett for technical guidance.
* Thanks to Reena Elangovan for technical guidance.
 

