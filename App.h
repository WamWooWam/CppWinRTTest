#pragma once
#include "App.g.h"

namespace winrt::CppWinRTTest::implementation
{
    struct App : AppT<App>
    {
        App() = default;

        void OnLaunched(Windows::ApplicationModel::Activation::LaunchActivatedEventArgs const& args);
    };
}
namespace winrt::CppWinRTTest::factory_implementation
{
    struct App : AppT<App, implementation::App>
    {
    };
}
