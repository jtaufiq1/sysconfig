const textarea = document.getElementById('textarea');
const sandbox = document.getElementById('sandbox');

const clipboardData = {};

document.addEventListener('copy', oncopy, false);

chrome.runtime.onMessage.addListener((message) => {
  sandbox.contentWindow.postMessage({
    cmd: message.cmd,
    data: message.data,
  }, '*');

  if(message.cmd === 'copy-data-to-clipboard') {
    handleClipboardWrite(message.data);
  }
})

window.addEventListener('message', (event) => {
  chrome.runtime.sendMessage({
    cmd: event.data.cmd,
    data: event.data.data,
  });
})

function oncopy(e) {
  e.preventDefault();
  e.clipboardData.setData(clipboardData.type || 'text/plain', clipboardData.data);
}

function handleClipboardWrite (data) {
  clipboardData.type = data.type;
  clipboardData.data = data.data;
  textarea.focus();
  document.execCommand('copy', false, null);
};