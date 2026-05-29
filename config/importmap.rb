# Pin npm packages by running ./bin/importmap

pin "application"
pin "bootstrap" # @5.3.8
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/index.js"
pin_all_from "https://ga.jspm.io/npm:@popperjs/core@2.11.8/lib/", under: "@popperjs/core/lib"

