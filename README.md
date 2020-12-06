# render_vue_component readme

Status: Doing

# render_vue_component

Build html block and pass Props for mounting Vue component in Ruby on Rails.

For example:
if there is SFC vue component named BaseComponent and task "user" as props
```js
export default {
  {
    props: ["user"]
  }
}
```
and render it in erb
```erb
<%= render_vue_component("ComponentName", user: @user) %>
```

# Installation

This gem should be always used with Rails app.

1. add `render_vue_component` in the `Gemfile`
2. run `bundle install`
3. run `yarn add render-vue-component` at the project's root path

# Usage

Here's some examples showing how to use this gem.

## Basic

Given files:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  root "pages#index"
end
```

```ruby
# app/controllers/pages_controller.rb
class PagesController < ApplicationController
  def index
  end
end
```

```erb
# app/view/layouts/application.html.erb
# add in <head>...</head>
<%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
<%= stylesheet_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
```

```erb
# app/view/pages/index.html.erb
<%= render_vue_component("BaseTag", text: 'Test1') %>
<%= render_vue_component("BaseTag", text: 'Test2') %>
```

We add a simple SFC takes a props "text" :

```vue
// app/javascript/components/BaseTag.vue
<template>
  <div class="base-tag">
    {{ text }}
  </div>
</template>

<script>
export default {
  name: "BaseTag",
  props: ["text"]
}
</script>

<style>
.base-tag {
  font-weight: bold;
}
</style>
```

We still need some JS codes to mount Vue component:

```js
// app/javascript/packs/application.js
// add these lines at the end of the file
import RenderVueComponent from "render-vue-component"
import BaseTag from "../components/BaseTag.vue"
RenderVueComponent.register({ BaseTag })

addEventListener("load", () => {
  RenderVueComponent.renderComponentsOnRails()
})
```

Run the rails server by `bundle exec rails s`

You should see the result in `http://localhost:3000`

## Custom Vue

Some developers may want to use their own Vue which uses Vuex, VueRouter, etc.

Vue can be set outside and then passed into RenderVueComponent.

```js
import RenderVueComponent from "render-vue-component"
import Vue from "vue"
import VueRouter from 'vue-router'
import Vuex from "vuex"
import router from "./router" // your router path
import store from "./store" // your Vuex store path
import BaseTag from "../components/BaseTag.vue"

Vue.use(VueRouter)
Vue.use(Vuex)
RenderVueComponent.setVue(Vue)
RenderVueComponent.register({ BaseTag })

addEventListener("load", () => {
  RenderVueComponent.renderComponentsOnRails({
    store,
    router,
  })
})
```

## Lazy load all components
```javascript
// app/javascript/packs/index.js
import Vue from "vue"
// require.cnotext can find all .vue files inside app/javascript recursively
const files = require.context("../", true, /\.vue$/i)
files.keys().map(key => {
  const component = key.split('/').pop().split('.')[0]
  const modulePath = key.replace(/^\.\//, "")
  
  Vue.component(component, () => import(`../${modulePath}`))
  // or without lazyloading
  // Vue.component(component, files[key].default)
})

import RenderVueComponent from "render-vue-component"
RenderVueComponent.setVue(Vue)

addEventListener("load", () => {
  RenderVueComponent.renderComponentsOnRails()
})
```

## Custom Serializer

In fact, render_vue_component just render the data to DOM first and use JS to parse them.

When render the data to DOM, it just use to_json method directly. So if you want to have correct JSON output, you have to specify the serializer. We use a serializer gem [blueprinter](https://github.com/procore/blueprinter) here for example:

We add a user serializer UserBluePrint first:

```ruby
# app/serializers/user_blueprint.rb
class UserBlueprint < Blueprinter::Base
  identifier :uuid

  fields :first_name, :last_name, :email
end
```

```ruby
# app/
class PagesController < ApplicationController
  def index
    user = {
      uuid: 1,
      first_name: 'Test',
      last_name: 'User',
      email: 'test.user@test.co',
    }
    @user = UserBlueprint.render_as_hash(user)
  end
end
```

```erb
<%= render_vue_component("BaseTag", user: @user) %>
```

We make a little change to our

```vue
// app/javascript/components/BaseTag.vue
<template>
  <div class="base-tag">
    {{ user.first_name }} {{ user.last_name }} | {{ user.email }}
  </div>
</template>

<script>
export default {
  name: "BaseTag",
  props: ["user"]
}
</script>

<style>
.base-tag {
  font-weight: bold;
}
</style>
```

Go to `http://localhost:3000` to see the changes

# The problem this gem wants to solve

Developing with Vue.js is a nice experience. Normally Vue.js project should be an complete SPA with  frontend router, and everything in the page is rendered by Vue.

However, using Vue.js in Rails, for myself, it's just because there is a component in a page which has lots of states needed to be managed and many actions needed to ben triggered when states changes. 

I still use rails router to change the pages,
