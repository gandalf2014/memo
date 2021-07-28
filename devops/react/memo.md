## Welcome


## CDN Settings
> use below code sneptet
> 

```javascript
<script src="https://cdn.staticfile.org/react/16.4.0/umd/react.development.js"></script>
<script src="https://cdn.staticfile.org/react-dom/16.4.0/umd/react-dom.development.js"></script>
<!-- 生产环境中不建议使用 -->
<script src="https://cdn.staticfile.org/babel-standalone/6.26.0/babel.min.js"></script>
```

## Npm settings
```
 cnpm install -g create-react-app
 create-react-app my-app
 cd my-app/
 npm start
```

## render element
```
const element = <h1>Hello, world!</h1>;
ReactDOM.render(
    element,
    document.getElementById('example')
);
```

## component definition
```
1、我们可以使用函数定义了一个组件：

function HelloMessage(props) {
    return <h1>Hello World!</h1>;
}
你也可以使用 ES6 class 来定义一个组件:

class Welcome extends React.Component {
  render() {
    return <h1>Hello World!</h1>;
  }
}

```


## React State(状态)
1. > React 把组件看成是一个状态机（State Machines）。通过与用户的交互，实现不同状态，然后渲染 UI，让用户界面和数据保持一致。
2. React 里，只需更新组件的 state，然后根据新的 state 重新渲染用户界面（不要操作 DOM）。
3. 以下实例创建一个名称扩展为 React.Component 的 ES6 类，在 render() 方法中使用 this.state 来修改当前的时间。
4. 添加一个类构造函数来初始化状态 this.state，类组件应始终使用 props 调用基础构造函数。
   
```
class HelloTest extends React.Component {
  constructor(props) {
    super(props);
    this.state = {name: this.props.name};
  }
 
  render() {
    return (
      <div>
        <h1>Hello, world!</h1>
        <h2>现在是 {this.state.name}.</h2>
      </div>
    );
  }
}
 
ReactDOM.render(
  <HelloTest name="gandalf" />,
  document.getElementById('example')
);
```

## React Props
> ### state 和 props 主要的区别在于 props 是不可变的，而 state 可以根据与用户交互来改变。这就是为什么有些容器组件需要定义 state 来更新和修改数据。 而子组件只能通过 props 来传递数据。


## react event handler
> 使用 React 的时候通常你不需要使用 addEventListener 为一个已创建的 DOM 元素添加监听器。你仅仅需要在这个元素初始渲染的时候提供一个监听器。
> 当你使用 ES6 class 语法来定义一个组件的时候，事件处理器会成为类的一个方法。

```
 constructor(props){
            super(props)
            this.state={name:this.props.name}
            this.handleChange = this.handleChange.bind(this); //绑定是必须的
        }
```

> 或者使用属性初始化
```
handleChange= (event)=>{
            this.setState({name:event.target.value})
        }
```

## note1
1. > 由于 JSX 就是 JavaScript，一些标识符像 class 和 for 不建议作为 XML 属性名。作为替代，React DOM 使用 className 和 htmlFor 来做对应的属性。

2. > 注意，原生 HTML 元素名以小写字母开头，而自定义的 React 类名以大写字母开头，比如 HelloMessage 不能写成 helloMessage。除此之外还需要注意组件类只能包含一个顶层标签，否则也会报错。


