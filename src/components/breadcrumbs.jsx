// Breadcrumbs code modified from: https://github.com/svenanders/react-breadcrumbs
//
// ISC License (ISC)
//
// Copyright (c) 2015, Sven Anders Robbestad
//
// Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby
// granted, provided that the above copyright notice and this permission notice appear in all copies.
//
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
// INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN
// AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
// PERFORMANCE OF THIS SOFTWARE.


import React, {Component} from "react"
import {Link} from "react-router"


export default class Breadcrumbs extends Component {
  render() {
    let {itemClassName, itemElement, linkClassName, params, routes, separator, wrapperClassName, wrapperElement} =
      this.props
    let parentPath = "/"
    let childrenInfos = routes.reduce(
      (childrenInfos, route, index) => {
        if (route.path) {
          if (route.path.charAt(0) === "/") {
            parentPath = route.path
          } else {
            if (parentPath.charAt(parentPath.length-1) !== "/") {
              parentPath += "/"
            }
            parentPath += route.path
          }
          const absolutePath = index > 0 && route.path.charAt(0) !== "/" ? parentPath : route.path

          let name = route.breadcrumbName
          if (!name) {
            let component = route.component
            if (component.WrappedComponent) component = component.WrappedComponent
            name = component.breadcrumbName
          }

          // Replace route params with their values (when provided) in path.
          const splitReplacedPath = absolutePath.split("/").map(pathItem => {
            if (pathItem.startsWith(":")) {
              const name = pathItem.substr(1)
              return name in params ? params[name] : pathItem
            } else {
              return pathItem
            }
          })

          if (!name) {
            name = splitReplacedPath[splitReplacedPath.length - 1]
            if (!name && splitReplacedPath.length > 1) name = splitReplacedPath[splitReplacedPath.length - 2]
          }
          if (!name) name = "Missing breadcrumbName from route"

          childrenInfos.push({
            name: name,
            params: route.params,
            path: splitReplacedPath.join("/"),
          })
        }
        return childrenInfos
      },
      [],
    )
    const lastIndex = childrenInfos.length - 1
    let childrenElement = childrenInfos.map(({name, params, path}, index) => {
      const linkElement = index === lastIndex ?
        React.createElement(itemElement, {className: itemClassName, key: `breadcrumb-${index}`}, name) :
        <Link className={linkClassName} key={`breadcrumb-${index}`} params={params} to={path}>{name}</Link>
      return [
        linkElement,
        index === lastIndex ? null : separator,
      ]
    })
    return React.createElement(wrapperElement, {className: wrapperClassName}, childrenElement)
  }
}

Breadcrumbs.propTypes = {
  itemClassName: React.PropTypes.string,
  itemElement: React.PropTypes.string,
  linkClassName: React.PropTypes.string,
  routes: React.PropTypes.arrayOf(React.PropTypes.object).isRequired,
  separator: React.PropTypes.string,
  wrapperClassName: React.PropTypes.string,
  wrapperElement: React.PropTypes.string,
}

Breadcrumbs.defaultProps = {
  itemClassName: "",
  itemElement: "span",
  linkClassName: "",
  separator: " > ",
  wrapperClassName: "breadcrumbs",
  wrapperElement: "div",
}

Breadcrumbs.contextTypes = {
  routes: React.PropTypes.array,
  params: React.PropTypes.array,
}


export default Breadcrumbs
