// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// app/javascript/packs/application.js

// 既存のコードの後に追加
document.addEventListener("turbolinks:load", function() {
  const url = new URL(window.location);
  if (url.searchParams.has('refresh')) {
    url.searchParams.delete('refresh');
    window.history.replaceState({}, document.title, url.pathname);
  }
});



