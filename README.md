# Rails Icons

Add any icon library to a Rails app. Rails Icons has first-party support for a [handful of libraries](#first-party-libraries). It is library agnostic so it can be used with any icon library using the same interface.

```erb
# Using the default icon library
<%= icon "check", class: "text-gray-500" %>

# Using any custom library
<%= icon "apple", library: "simple_icons", class: "text-black" %>
```

The icons are pulled from their respective GitHub repositories, keeping Rails icons' core lightweight.


**Sponsored By [Rails Designer](https://railsdesigner.com/)**

<a href="https://railsdesigner.com/" target="_blank">
  <img src="https://raw.githubusercontent.com/Rails-Designer/rails_icons/main/docs/rails_designer_icon.jpg" alt="Rails Designer logo"  width="240" />
</a>


## Install

Add the rails_icons gem:
```bash
bundle add rails_icons
```

Install, choosing one of the supported libraries
```bash
rails generate rails_icons:install --libraries=LIBRARY_NAME
```

**Example**:
```bash
rails generate rails_icons:install --libraries=heroicons
```

Or multiple at once:
```bash
rails generate rails_icons:install --libraries=heroicons,lucide
```


## Sync icons

If a library gets updated, sync the icons to your app by running:

```bash
rails generate rails_icons:sync --libraries=LIBRARY_NAME
```

**Example**:
```bash
rails generate rails_icons:sync --libraries=heroicons
```

Or multiple at once:
```bash
rails generate rails_icons:sync --libraries=heroicons,lucide
```


## Usage

```ruby
# Uses the default library and variant defined in config/initializer/rails_icons.rb
icon "check"

# Use another variant
icon "check", variant: "solid"

# Set library explictly
icon "check", library: "heroicons" hero

# Add CSS
icon "check", class: "text-green-500"

# Add data attributes
icon "check", data: { controller: "swap" }

# Set the stroke-width
icon "check", stroke_width: 2
```


## First-party Libraries

- [Heroicons](https://github.com/tailwindlabs/heroicons)
- [Lucide](https://github.com/lucide-icons/lucide)
- [Tabler](https://github.com/tabler/tabler-icons)


## Custom icon library

Need to use an icon from another library?

1. add the (SVG) icon to **app/assets/svgs/LIBRARY_NAME/DEFAULT_VARIANT**;
2. run `rails generate rails_icons:initializer --library=custom`.

Every added custom icon can now be used with the same interface as first-party icon libraries.

```ruby
icon "apple", library: "simple_icons", class: "text-black"
```


## Contributing

This project uses [Standard](https://github.com/testdouble/standard) for formatting Ruby code. Please make sure to run `be standardrb` before submitting pull requests. Run tests via `rails test`.


## License

Rails Icons is released under the [MIT License](https://opensource.org/licenses/MIT).
