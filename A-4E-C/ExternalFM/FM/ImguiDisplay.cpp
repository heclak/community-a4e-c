#include <ImguiDisplay.h>

#include <FmGui.hpp>
#include <functional>
#include <imgui.h>

#include "Globals.h"


std::unique_ptr<ImguiDisplay> ImguiDisplay::display = nullptr;

void ImguiDisplay::AddImguiItem( const std::string& menu, const std::string& name, std::function<void()>&& imgui_function )
{
#ifndef DISABLE_IMGUI
    const std::unique_ptr<ImguiDisplay>& display = Get();
    if ( display == nullptr )
    {
        LOG( "No Imgui" );
        return;
    }

    Menu& imgui_menu = display->menus[menu];
    imgui_menu.items.emplace_back();

    MenuItem& imgui_menu_item = imgui_menu.items.back();
    imgui_menu_item.imgui_function = std::move( imgui_function );
    imgui_menu_item.name = name;
#endif
}


#ifndef DISABLE_IMGUI

void ImguiDisplay::DisplayHook()
{
    const std::unique_ptr<ImguiDisplay>& display = Get();
    if ( display )
        display->Display();
}

void ImguiDisplay::InputHook( UINT msg, WPARAM w_param, LPARAM l_param )
{
    const std::unique_ptr<ImguiDisplay>& display = Get();
    if ( display )
        display->Input( msg, w_param, l_param );
}

ImguiDisplay::ImguiDisplay()
{
    FmGuiConfig config;
    config.imGuiStyle = FmGuiStyle::CLASSIC;

    if ( ! FmGui::StartupHook(config) )
    {
        LOG( "FmGui::StartupHook failed.\n" );
    }
    else
    {
        LOG( "D3D11 Context: %s\n", FmGui::AddressDump().c_str() );

        FmGui::SetInputRoutinePtr( InputHook );
        FmGui::SetRoutinePtr( DisplayHook );
        FmGui::SetWidgetVisibility( true );
    }
}

void ImguiDisplay::Display()
{
    if ( menus.empty() )
        return;


    if ( ImGui::BeginMainMenuBar() )
    {
        for ( auto& [menu_name, menu] : menus )
        {
            if ( ! ImGui::BeginMenu( menu_name.c_str() ) )
            {
                continue;
            }

            for ( auto& menu_item : menu.items )
            {
                if ( ImGui::MenuItem( menu_item.name.c_str() ) )
                {
                    menu_item.visible = true;
                }
            }

            ImGui::EndMenu();
        }

        ImGui::EndMainMenuBar();
    }

    for ( auto& [menu_name, menu] : menus )
    {
        for ( auto& menu_item : menu.items )
        {

            if ( ! menu_item.visible )
            {
                continue;
            }

            std::string path = menu_name + "/" + menu_item.name;
            if ( ImGui::Begin(path.c_str(), &menu_item.visible ) )
            {
                menu_item.imgui_function();
                ImGui::End();
            }
        }
    }

}

void ImguiDisplay::Input( UINT msg, WPARAM w_param, LPARAM l_param )
{
    
}


#endif