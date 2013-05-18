# i18n_tools

Very simple rake tasks for finding missing and unused translations in Rails and Ruby applications using the
`I18n` library.

## Installation

```
gem install i18n_tools
```

## Usage

If you use bundler in Rails, add the following to your `Rakefile`:

```ruby
group :development do
  gem 'i18n_tools'
end
```

If you use bundler outside of Rails, use

```ruby
gem 'i18n_tools', :require => 'i18n_tools/tasks'
```

Finally, if you're not using bundler, then include the following snippet into your `Rakefile`:

```ruby
begin
  require 'i18n_tools/tasks'
rescue LoadError
end
```

The begin and rescue block makes sure that your `Rakefile` won't report an error when the gem is not installed. This is because the gem is clearly only useful while developing.

Now you can run the following tasks:

* `LOCALE=xyz rake translations:missing` -- detects missing translations from your project in locale xyz
  and outputs them to stdout in YAML format.
* `LOCALE=xyz rake translations:unused` -- detects translations in locale xyz that are not used by any of
  your code and outputs the translation keys.
* `rake translations:merge` -- will merge new translations added to the bottom of the YAML file into the
  rest of the file. Make sure the parts are separated by a line containing three dashes (`---`). The easiest
  way to do this is by using `rake translations:missing` and copy the output into the YAML file before running
  this task.

## Tweaking it

By default, `i18n_tools` looks for ruby code inside the `app/` directory as well as views inside `app/views/`.
If you use non-standard locations (such as `"modules/"` or something like that), add the following to your
Rakefile:

```ruby
I18nTools::Scanner.code_paths << "modules/**/*.rb"
```

For non-standard view paths, use

```ruby
I18nTools::Scanner.view_paths << "app/mailer_views/**/*.erb"
```

Some files might contain parts that look like calls to the translation library, but actually aren't. To
exclude these files from the output, write them into the file `.i18nignore` in your `Rails.root`, as regular
expressions, one per line. Empty lines or lines starting with `#` are ignored.

There is something special about the `translations:unused` task. In its default configuration it might
report things that are actually used. To exclude these false positives, enter each key prefix to ignore
into the file `.i18nignore_unused` (omit the locale).

## Contributing

As usual, fork, commit, pull request.
