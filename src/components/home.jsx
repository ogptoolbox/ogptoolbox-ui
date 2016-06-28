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


import {Component} from "react"


export default class Home extends Component {
  render() {
    return (
      <section>
        <h1>Welcome to the OGPToolbox editor</h1>
        <p>
          France will host the <strong>Open Government Partnership 2016 Global Summit in Paris on December 7, 8 and 9</strong>.
        </p>
        <p>
          As announced at the Global Summit launch event on April 20, a <strong>hackathon on civic technology</strong> and the practical implementation of open government principles and national commitments will take place during the Global Summit. The goal of this hackathon is to come up with an open government toolbox for the OGP, governments and civil society.
        </p>
        <p>
          Open data portals, public consultation platforms, tools for monitoring and co-creating the law, discussion forums, civic technology, and online platforms to monitor the implementation of national action plans: these are examples of software tools and online services used by governments and civil society around the world, which could be referenced, shared and reused.
        </p>
        <p>
          <strong>This toolbox will be based on a software catalogue, including examples of uses and practices to help choose among available solutions.</strong> It aims at facilitating the implementation of national commitments made by governments in their national action plans and encouraging cooperation, experience and resources sharing between OGP members.
        </p>
        <p>
          Until December, sprints and workshops will be organized for public officials, civil society representatives, companies, start-ups and members of the civic tech ecosystem to meet and work on the toolbox. The toolbox will be presented at the end of the hackathon during the OGP 2016 Global Summit, on December 8 and 9
        </p>
        <hr />
      </section>
    )
  }
}
