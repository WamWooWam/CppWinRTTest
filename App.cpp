#include "pch.h"
#include "App.h"
#include "winrt/Windows.UI.Popups.h"

using namespace winrt;
using namespace Windows::ApplicationModel;
using namespace Windows::ApplicationModel::Activation;
using namespace Windows::Foundation;
using namespace Windows::UI::Popups;
using namespace Windows::UI::Xaml;
using namespace Windows::UI::Xaml::Controls;
using namespace Windows::UI::Xaml::Navigation;

namespace winrt::CppWinRTTest::implementation
{
    void App::OnLaunched(Windows::ApplicationModel::Activation::LaunchActivatedEventArgs const& args)
    {
        Window wind = Window::Current();
        Grid root = wind.Content().try_as<Grid>();
        if (root == nullptr) {
            // OnLaunched can be called when the app already has content, so only set content if 
            // there wasn't any already
            root = Grid();
   
            Button button;
            button.Content(box_value(L"Hello, world!"));
            button.HorizontalAlignment(HorizontalAlignment::Center);
            button.VerticalAlignment(VerticalAlignment::Center);
            button.Click([](auto&&, auto&&) -> IAsyncAction {
                MessageDialog dialog{ L"Wow! I'm so impressed! You must be super proud of yourself.", L"You clicked a button!" };
                co_await dialog.ShowAsync();
            });

            root.Children().Append(button);
        }

        wind.Activate(); // windows will kill us if we don't call this.
    }
}
