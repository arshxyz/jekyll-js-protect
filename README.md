# 🧧 jekyll-js-protect

Protect sensitive info (emails/phone numbers) on your Jekyll site from scrapers and bots.

## 🔴 Install
1. Add `jekyll-js-protect` in your `Gemfile` like so
```ruby
gem 'jekyll-js-protect'
```
2. Run `bundle install`

## ♦️ Usage
There are 3 [Liquid Filters](https://shopify.dev/docs/api/liquid/filters) that this plugin exposes, `string_protect`, `email_protect` and `tel_protect`.
`email_protect` and `tel_protect` will add `mailto:` and `tel:` links resepectively.

For other info (or if you don't want your email/number to be clickable) use the `string_protect` tag.

The markup below
```liquid
Bots can't read this: {{'I like pineapples' | string_protect}}

My email address is {{'dont@spam.me' | email_protect}}

You can call me at {{'9999999999' | tel_protect}}
```
Renders:

<img width="400" alt="image" src="https://github.com/arshxyz/jekyll-js-protect/assets/23417273/658c2263-11aa-4412-973b-0c92a2f34dd0">

## 📕 How it works
- The input to the Filter is encoded in Base64 then prefixed with a code
- A [Jekyll Hook](https://jekyllrb.com/docs/plugins/hooks/) adds a tiny JS file to your pages
- When the JS file loads it decodes the encoded info
- Since webcrawlers used for collecting emails do not typically have a JS stack it protects against such bots

## 🧰 Misc
- A `<noscript>` fallback is provided for when JS is disabled.
  
<img width="646" alt="image" src="https://github.com/arshxyz/jekyll-js-protect/assets/23417273/64b4fd1c-53e0-4e9e-ba03-fc31d0de3ab7">

- It is assumed that anyone who chooses to disable JS on their browser knows how to decode Base64 strings
