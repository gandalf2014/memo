## CDN Settings
```
<script src="https://unpkg.com/vue@next"></script>
```

### npm settings
```
# 最新稳定版
$ cnpm install vue@next
# 全局安装 vue-cli
$ cnpm install -g @vue/cli
# 安装完后查看版本
# cnpm i -g @vue/cli-init
$ vue --version
@vue/cli 4.5.11
```

## create projects
```
$ vue init webpack test1
$ cd test1
$ cnpm run dev
```

## 使用vite创建项目
```
npm init @vitejs/app myapp
$ cd myapp
$ cnpm install
$ cnpm run dev
```

## vue ui 创建项目
```
# vue ui
```

## 指令 绑定属性v-bind (:herf), v-on(绑定事件 @click) v-model(表单元素双向绑定)

## computed vs methods
> 我们可以使用 methods 来替代 computed，效果上两个都是一样的，但是 computed 是基于它的依赖缓存，只有相关依赖发生改变时才会重新取值。而使用 methods ，在重新渲染的时候，函数总会重新调用执行。


## 路由 
```
npm install -g cnpm --registry=https://registry.npm.taobao.org
cnpm install vue-router@4
```

## Vue3 ajax: axios