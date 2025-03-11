"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[331],{3905:(e,t,n)=>{n.d(t,{Zo:()=>u,kt:()=>m});var r=n(67294);function o(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function a(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function i(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?a(Object(n),!0).forEach((function(t){o(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):a(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,r,o=function(e,t){if(null==e)return{};var n,r,o={},a=Object.keys(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(r=0;r<a.length;r++)n=a[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var s=r.createContext({}),c=function(e){var t=r.useContext(s),n=t;return e&&(n="function"==typeof e?e(t):i(i({},t),e)),n},u=function(e){var t=c(e.components);return r.createElement(s.Provider,{value:t},e.children)},p="mdxType",d={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},f=r.forwardRef((function(e,t){var n=e.components,o=e.mdxType,a=e.originalType,s=e.parentName,u=l(e,["components","mdxType","originalType","parentName"]),p=c(n),f=o,m=p["".concat(s,".").concat(f)]||p[f]||d[f]||a;return n?r.createElement(m,i(i({ref:t},u),{},{components:n})):r.createElement(m,i({ref:t},u))}));function m(e,t){var n=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var a=n.length,i=new Array(a);i[0]=f;var l={};for(var s in t)hasOwnProperty.call(t,s)&&(l[s]=t[s]);l.originalType=e,l[p]="string"==typeof e?e:o,i[1]=l;for(var c=2;c<a;c++)i[c]=n[c];return r.createElement.apply(null,i)}return r.createElement.apply(null,n)}f.displayName="MDXCreateElement"},76647:(e,t,n)=>{n.r(t),n.d(t,{contentTitle:()=>i,default:()=>p,frontMatter:()=>a,metadata:()=>l,toc:()=>s});var r=n(87462),o=(n(67294),n(3905));const a={},i="Avatar editor utils",l={type:"mdx",permalink:"/avatareditor/",source:"@site/pages/index.md",title:"Avatar editor utils",description:"Some promise-based methods to deal with Roblox Avatar Editor Service, Humanoid Descriptions and Web APIs easier",frontMatter:{}},s=[{value:"Instalation",id:"instalation",level:2},{value:"Usage",id:"usage",level:2},{value:"Contributing",id:"contributing",level:2},{value:"License",id:"license",level:2}],c={toc:s},u="wrapper";function p(e){let{components:t,...n}=e;return(0,o.kt)(u,(0,r.Z)({},c,n,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("h1",{id:"avatar-editor-utils"},"Avatar editor utils"),(0,o.kt)("p",null,"Some ",(0,o.kt)("a",{parentName:"p",href:"https://eryn.io/roblox-lua-promise/"},"promise"),"-based methods to deal with Roblox Avatar Editor Service, Humanoid Descriptions and Web APIs easier"),(0,o.kt)("h2",{id:"instalation"},"Instalation"),(0,o.kt)("p",null,"For Studio users: There's a model in my profile, I can't put the link here \ud83d\udc80"),(0,o.kt)("p",null,"For Rojo users, just put the MainModule folders inside your Server/Client directory and the Promise inside ReplicatedStorage"),(0,o.kt)("h2",{id:"usage"},"Usage"),(0,o.kt)("p",null,"The function names are pretty self-explanatory. Don't forget to do your type checking before calling the function"),(0,o.kt)("p",null,"Make sure to put nil in the string parameters that you won't use"),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-lua"},'Players.PlayerAdded:Connect(function(player)\n        Main:GetUserInventoryAsync(player.UserId, nil):andThen(function(Response)\n            Main:GetItemsByCategory("1", nil, nil, nil, nil):andThenCall(foo, "args")\n        end)    \nend)\n')),(0,o.kt)("h2",{id:"contributing"},"Contributing"),(0,o.kt)("p",null,"Consider making a issue for major changes. Pull requests are welcome!!"),(0,o.kt)("p",null,"Please make sure to update tests as appropriate."),(0,o.kt)("h2",{id:"license"},"License"),(0,o.kt)("p",null,(0,o.kt)("a",{parentName:"p",href:"https://choosealicense.com/licenses/mit/"},"MIT")))}p.isMDXComponent=!0}}]);