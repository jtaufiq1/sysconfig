var popup =
{
   init: function()
   {
      var tabs = chrome.tabs || brower.tabs;
      var runtime = chrome.runtime || browser.runtime;

      tabs.create({'url': runtime.getURL('reader.html'), 'active': true});
      window.close();
   }
}

window.addEventListener("DOMContentLoaded", popup.init, true);