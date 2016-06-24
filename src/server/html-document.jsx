// OGPToolbox-Editor -- Web editor for OGP toolbox
// By: Emmanuel Raviart <emmanuel.raviart@data.gouv.fr>
//
// Copyright (C) 2016 Etalab
// https://git.framasoft.org/etalab/ogptoolbox-editor
//
// OGPToolbox-Editor is free software; you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// OGPToolbox-Editor is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


import DocumentTitle from "react-document-title"
import React, {Component, PropTypes} from "react"


class HtmlDocument extends Component {
  static propTypes = {
    appHtml: PropTypes.string.isRequired,
    appInitialState: PropTypes.object,
    cssUrls: PropTypes.arrayOf(PropTypes.string),
    jsUrls: PropTypes.arrayOf(PropTypes.string),
  }
  render() {
    const {appHtml, cssUrls, appInitialState, jsUrls} = this.props
    return (
      <html lang="en">
        <head>
          <meta charSet="UTF-8" />
          <meta httpEquiv="X-UA-Compatible" content="IE=edge" />
          <meta content="width=device-width, initial-scale=1.0, user-scalable=no" name="viewport" />
          <title>{DocumentTitle.rewind()}</title>
          <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/latest/css/bootstrap.min.css" />
          {cssUrls && cssUrls.map((href, key) => <link href={href} key={key} rel="stylesheet" type="text/css" />)}
        </head>
        <body style={{paddingTop: "70px"}}>
          <div dangerouslySetInnerHTML={{__html: appHtml}} id="app-mount-node" />
          {
            appInitialState && (
              <script
                dangerouslySetInnerHTML={{__html: `window.__INITIAL_STATE__ = ${JSON.stringify(appInitialState)}`}}
              />
            )
          }
          {jsUrls && jsUrls.map((src, idx) => <script key={idx} src={src} />)}
        </body>
      </html>
    )
  }
}

export default HtmlDocument
