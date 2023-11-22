# DCS EFM ImGui (FmGui)

![In-game image.](Images/InDCS.png)

FmGui is a project that implements the Dear ImGui library, and optionally the
ImPlot extension, for use with the DCS: World EFM API. Its purpose is to greatly
ease the development process of the user's EFM.

# Table of Contents

- [1 Installing Binaries](#installing)
- [2 Building](#building)
  - [2.1 Setting Up ImGui](#imgui)
  - [2.2 Setting Up ImPlot](#implot)
  - [2.3 Setting Up MinHook](#minhook)
- [3 Examples](#examples)
- [4 Configuration](#config)
- [5 Note](#note)
- [6 License](#license)

## 1. Installing Binaries: <a name="installing"></a>

<p style="color:blue">
  Note: This section is a work in progress. It is recommended that you build the
  library yourself at this time.
</p>

## 2 Building: <a name="building"></a>
To use the [Include/FmGui.hpp](Include/FmGui.hpp) and
[Source/FmGui.cpp](Source/FmGui.cpp) source files, they must be included in the
user's EFM Visual Studio or CMake project. In Visual Studio you can add existing
file(s) as seen below.

![Add Existing](Images/AddExisting.png)

The user will need to have the "Desktop development with C++" and
"Game development with C++" Visual Studio workloads installed to successful
build these source files. The "Game development with C++" workload is needed,
because it contains the DirectX SDK. The process for installing these workloads
can be seen below.

![Modify Workloads](Images/Modify.png)

![Add Workloads](Images/Workloads.png)

The source files use the ImGui, ImPlot (optionally), and MinHook libraries.

You may find ImGui v1.87
[here](https://github.com/ocornut/imgui/releases/tag/v1.87)
ImPlot v0.13
[here](t/implot/releases/tag/v0.13), and you can find
MinHook v1.3.3
[here](https://github.com/TsudaKageyu/minhook/releases/tag/v1.3.3).

### 2.1 Setting Up ImGui <a name="imgui"></a>

Including ImGui in your EFM project is really simple. FmGui assumes that you
store the ImGui source files in their original folder and add them to your
project's include path. For example, consider the following folder structure
below.

- EFM
  - lib
    - imgui-1.87
      - imgui
        - imconfig.h
        - imgui.cpp
        - imgui.h
        - imgui_demo.cpp
        - imgui_draw.cpp
        - imgui_impl_dx11.cpp
        - imgui_impl_dx11.h
        - imgui_impl_win32.cpp
        - imgui_impl_win32.h
        - imgui_interal.h
        - imgui_tables.cpp
        - imgui_widgets.cpp
        - imstb_rectpack.h
        - imstb_textedit.h
        - imstb_truetype.h
        - ...
      - ...
  - MY_EFM_PROJECT
    - FmGui.hpp
    - FmGui.cpp
    - .vcxproj in this directory.
    - ...
  - .sln in this directory.
  - ...

In Visual Studio select your project in the Solution Explorer and then add the
following entry to *Configuration Properties -> C/C++ -> General -> Additional
Include Directories*: `$(ProjectDir)..\lib\imgui-1.87\imgui\`

Since ImGui is distributed in source form you must add the .cpp files to your
project as seen earlier. You can also press Shift + Alt + A and select imgui.cpp, imgui_demo.cpp (not optional), imgui_draw.cpp, imgui_impl_dx11.cpp,
imgui_impl_win32.cpp, imgui_tables.cpp, and imgui_widgets.cpp.

You could also add the header files to your include path, but FmGui assumes the
ImGui headers can be found in the current working directory.

### 2.2 Setting Up ImPlot <a name="implot"></a>

ImPlot is an extension for ImGui that add many useful new widgets such as plots,
graphs, charts, and more.

An ImPlot directory setup might look like this:
- EFM
  - lib
    - implot-0.13
      - implot.cpp
      - implot.h
      - implot_demo.cpp
      - implot_internal.h
      - implot_items.cpp
      - ...
    - ...
  - MY_EFM_PROJECT
    - FmGui.hpp
    - FmGui.cpp
    - .vcxproj in this directory.
    - ...
  - .sln in this directory.
  - ...

In Visual Studio select your project in the Solution Explorer and then add the
following entry to *Configuration Properties -> C/C++ -> General -> Additional
Include Directories*: `$(ProjectDir)..\lib\implot-0.13\`

Much like ImGui, ImPlot is distributed in the source form so you need to add
the .cpp files to your project in the same manner. You can press Shift + Alt + A and select implot.cpp, implot_demo.cpp (not optional), and implot_items.cpp.

Note: you do not have to use the ImPlot extension to use/build FmGui. You can
disable ImPlot as shown in the source code example below:
```c++
/* In file FmGui.hpp */
/*
 * Simply comment out the "#define FMGUI_ENABLE_IMPLOT" line as seen below.
 */
// Define FMGUI_ENABLE_IMPLOT to enable the ImPlot extension.
// #define FMGUI_ENABLE_IMPLOT
```

### 2.3 Setting Up MinHook <a name="minhook"></a>

As for the MinHook v1.3.3 release, assume the same project directory
structure.

- EFM
  - lib
    - MinHook_133 (directory has been renamed)
      - lib
        - libMinHook-v\<Platform Toolset\>-\<Run-time Type\>.x64.lib
        - ...
      - include
        - ...
    - ...
  - MY_EFM_PROJECT
    - FmGui.hpp
    - FmGui.cpp
    - .vcxproj in this directory.
    - ...
  - .sln in this directory.
  - ...- FmGui.hpp
    - FmGui.cpp
    - .vcxproj in this directory.

I personally recommended downloading the the
[static library release](https://github.com/TsudaKageyu/minhook/releases/download/v1.3.3/MinHook_133_lib.zip)
for MinHook or building it from source. That way you don't have to worry about
having multiple dynamic link libraries in your aircraft mod's bin folder.

To add the include directory and link statically for the MinHook static library
release you can use the following instructions:

In Visual Studio select your project in the Solution Explorer and then add the
following entry to *Configuration Properties -> C/C++ -> General -> Additional
Include Directories*: $(ProjectDir)..\lib\MinHook_133\include\

Select *Configuration Properties -> Linker -> General -> Additional Libraries
Directories* and add $(ProjectDir)/../lib/MinHook_133/lib/

In the MinHook_133/lib/ directory, you will see several different static
libraries. You will most likely want to link against libMinHook-x64-v141-mt.lib
for your release builds and  libMinHook-x64-v141-mtd.lib for your debug builds.
Add these for you different configurations in *Configuration Properties ->
Linker -> Input -> Additional Dependencies*.

Phew, I think that's everything.

## 3. Examples: <a name="examples"></a>
Checkout the Examples directory for code samples on this library's usage.

See [Examples/Fm.cpp](Examples/Fm.cpp)

For a library reference simply view the FmGui.hpp header file and its
commented functions.

## 4. Configuration: <a name="config"></a>

Currently there are no real configuration options available, but those will be
added in the future.

## 5. Note: <a name="note"></a>
Please **do not** use these source files maliciously. This code is meant to
aide the user in developing an EFM with the powerful ImGui widgets library.

These source files were built and tested using Visual Studio Community 2022,
Windows 10 SDK Version 10.0.19041.0, the C++20 Standard, the MinHook library
v1.3.3, the DirectX SDK Version _____, and the ImGui library version 1.87.

The minimum C++ ISO Standard requirement for these files is C++11.

## 6. License: <a name="license"></a>

This project is licensed under the permissive BSD 2-Clause License. For more
details view [LICENSE.txt](LICENSE.txt)

