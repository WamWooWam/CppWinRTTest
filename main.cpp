#include "pch.h"
#include "App.h"
#include <iostream>

int wmain(int argc, wchar_t* argv[])
{
    winrt::init_apartment();
    winrt::Windows::UI::Xaml::Application::Start([](auto&&) { winrt::make<winrt::CppWinRTTest::implementation::App>(); });
    return 0;
}
