/**
 @license EPUBReader: http://www.epubread.com/
 Copyright (C) 2022 Michael Volz (epubread at gmail dot com). All rights reserved.

 It's not permitted to copy from, to modify or redistribute this script or it's source.
 See the attached license (license.txt) for more details.

 You should have received a copy of the license (license.txt)
 along with this program. If not, see <http://www.epubread.com/license/>.

 THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED WARRANTIES,
 INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL JCRAFT,
 INC. OR ANY CONTRIBUTORS TO THIS SOFTWARE BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

var tabs = chrome.tabs || browser.tabs;
var extension = chrome.extension || browser.extension;
var runtime = chrome.runtime || browser.runtime;
var i18n = chrome.i18n || browser.i18n;
var storage = chrome.storage || browser.storage;

function handleInstall(data)
{
   var pref = data["pref"];

   if(pref["version"] == 0)
   {
      storage.local.set({"pref": {"version": currentVersion}});

      if(typeof i18n.getUILanguage === "function")
      {
         var lang = "?lang=" + i18n.getUILanguage();
      }
      else
      {
         var lang = "";
      }

      tabs.create({"url":"https://epubread.com/welcome_new.php" + lang, "active":true});
   }
   else if(pref["version"] != currentVersion)
   {
      storage.local.set({"pref": {"version": currentVersion}});
   }
}

runtime.setUninstallURL("https://www.epubread.com/goodbye.php");

var currentVersion = runtime.getManifest()["version"];
storage.local.get({"pref": {"version": 0}}, handleInstall);

runtime.onMessageExternal.addListener(handleApiRequest);
var currentTab = -1;

function handleApiRequest(message, sender, sendResponse)
{
   function sendRequest(currentTab, message, sendResponse)
   {
      tabs.sendMessage(currentTab, message, function(response)
      {
         if(!runtime.lastError && response)
         {
            response.success = true;
            sendResponse(response);
         }
         else
         {
            sendResponse({success: false});
         }
      });
   }

   if(message.name == "getDocumentInfo")
   {
      tabs.query({active: true}, function(result)
      {
         currentTab = result[0].id;
         sendRequest(currentTab, message, sendResponse);
      });
   }
   else if(currentTab != -1)
   {
      sendRequest(currentTab, message, sendResponse);
   }
   else
   {
      sendResponse({success: false});
   }

   return true;
}