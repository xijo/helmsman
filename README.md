# Helmsman

[![Build Status](https://secure.travis-ci.org/xijo/helmsman.png?branch=master)](https://travis-ci.org/xijo/helmsman) [![Gem Version](https://badge.fury.io/rb/helmsman.png)](http://badge.fury.io/rb/helmsman) [![Code Climate](https://codeclimate.com/repos/523f6d34c7f3a34a75017842/badges/af7056196f756e73e540/gpa.png)](https://codeclimate.com/repos/523f6d34c7f3a34a75017842/feed)

## Installation

Add this line to your application's Gemfile:

    gem 'helmsman'

And then execute:

    $ bundle

## Usage

Helmsman adds the `helm` helper to your rails application views. Here is how you use it:

```ruby
helm :pictures, url: 'http://defiant.ncc/pictures'
```

The above call will produce the following html output

```html
<li>
  <a href='http://defiant.ncc/pictures'>Pictures</a>
</li>
```

### Building the link

There are multiple ways to build the link:

1. provide the url parameter. The link will then be build by using the translation and that url.

```ruby
helm :pictures, url: 'http://randompictures.com'
```

2. set helm values in a block.

```ruby
helm :pictures do |entry|
  entry.name = 'Some pictures'
  entry.url  = 'http://randompictures.com'
end
```

3. build everything manually

```ruby
helm :pictures do |_|
  link_to 'Some pictures', 'http://randompictures.com'
end
```

### Translation lookup

The first parameter will be used to lookup the translations.

e.g. `helm :edit` called from `app/views/pictures/_menu.html.*` uses the following translations

- en.pictures.menu.edit
- en.pictures.menu.edit_disabled

### Highlight current

Helmsman will highlight the current entry by using the controller and action name.

Per default the first parameter will be treated as the controller name: `helm :pictures, url: pictures_url` highlights on every controller action of the pictures_controller.

You may customize the highlight options by providing a set of controller and/or action names. Here are some examples:

```ruby
helm :bridge, controllers: :screens                           # on any screens controller action
helm :bridge, controllers: [:screens, :sensors]               # on any screens and sensors controller action
helm :bridge, actions: :show                                  # on bridges controller show action
helm :bridge, controllers: :screens, actions: [:show, :index] # only on screens controller #show and #index
```

Anyway you are not forced to use that mechanism, you can also set `current` by hand:

```ruby
helm :bridge, current: true
```

### Disabling and visibility

To set a helm disabled you may use the `disabled` option. It will then add a tooltip to that entry to explain why it was disabled.

```ruby
admin_sidebar_entry :pictures, url: pictures_url, disabled: user_signed_in?
```

If you want it to not be visible at all set the `visible` option to false.

```ruby
admin_sidebar_entry :pictures, url: pictures_url, visible: user_signed_in?
```

### Additional content and nesting

As mentioned above you may additional content and nest helms into each other by using its yield feature. Here is a SLIM example:

```slim
- helm :pictures, url: 'http://allpictures.com' do
  ul
    = helm :architecture
    = helm :nature
```

You can always use the current helm during that yield, so finding out whether it is disabled, current or anything is trivial:


```ruby
admin_sidebar_entry :pictures, disabled: true, current: false do |entry|
  puts entry.enabled?   # false
  puts entry.disabled?  # true
  puts entry.visible?   # true
  puts entry.current?   # false
end
```

## Compatibility

Helmsman is working for rails 3 & 4 and for any ruby >= 1.9.3

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## TODO

1. configure helper name
2. configure current/disabled class
