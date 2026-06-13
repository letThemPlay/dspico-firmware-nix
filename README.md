# dspico-firmware-nix

A **Nix flake** designed to seamlessly pull, patch, and cross-compile the [LNH-team/dspico-firmware](https://github.com/LNH-team/dspico-firmware) for the RP2040-powered **DSpico flashcart**.

This repository eliminates the need to manually install dependencies like `arm-none-eabi-gcc`, CMake, or Docker. Everything required to generate your `.uf2` binary is managed inside a reproducible Nix environment.

---

## 🛠️ Features

* **Reproducible Builds**: Locked toolchain prevents "works on my machine" issues.

---

## 🚀 Getting Started

### Prerequisites

You must have **Nix** installed with flakes enabled. If you do not have it, install it via the [Determinate Nix Installer](https://determinate.cc): Follow directions of their website.

### Building the firmware

1. Clone this repository
2. Place the required bios files inside the files folder [see](files/README.md)
3. Run the following command

```bash
# Hybrid
nix build .#default
```

```bash
# wrfuxxed patched
nix build .#wrfuxxed-firmware
```

The resulting firmware will be placed in `result/share/DSpico.uf2`.

---

## ⚡ Flashing Your Device

1. Remove the MicroSD card from your **DSpico** cart.
2. Connect the DSpico to your computer using a Micro-USB cable. (It will automatically enter `BOOTSEL` mode).
3. A volume named `RPI-RP2` will mount on your operating system.
4. Copy the compiled `DSpico.uf2` file into the `RPI-RP2` volume.
5. The volume will automatically unmount and your DSpico is updated!

---

## 🤝 Acknowledgements

* [LNH-team](https://github.com/LNH-team) for designing and developing the DSpico hardware and core firmware.
* The NixOS community for maintaining robust ARM cross-compilation toolchains.
