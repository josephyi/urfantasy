@About = React.createClass

  render: ->
    return (
      <div className="page">
        <h1>About</h1>
        <h2>For what it's wurf</h2>
        <p>My friend Danny (<a href="https://twitter.com/dbanksdesign">@dbanksdesign</a>) and I
        (<a href="https://twitter.com/josephyi">@josephyi</a>) created this site for the
        <a href="https://developer.riotgames.com/discussion/riot-games-api/show/bX8Z86bm">Riot Games API Challenge</a>.
        We originally wanted to make a champion fantasy application, but due to
        time constraints and the fact that URF was over before the contest ended, we decided
        to work on a data exploration app instead (however, we kept the fantasy score metric as a means to measure
        overall rank). It's a little rough around the edges, but we're having as much fun using it as we did making it.
        There's a lot of cool tech behind the scenes, so if you're
        curious, be sure to check out the technical details on this project's
        <a href="https://github.com/josephyi/urfantasy">Github repo</a>.
        </p>
        <h2>How to use the Treemap</h2>
        <p>The treemap visualization on the entry page is backed by aggregated data from the 490,000+
        URF matches provided by the API Challenge. Unlike tables of stats that allow sorting
        by individual categories, the treemap offers a multidimensional perspective via combinations of
        criteria, which makes finding interesting discoveries a matter of size and color. For example, you can choose
        size by 'Picks' and color by 'Win Rate' to see how often champions are picked vs how often they win. Combined
        with the region and day filters, we hope the unique treemap experience is fun to use and leads you to
        finding something interesting! If you want more information about a champion's URF performance,
        click an individual champion's box to view a flyout with some summary information (contextual to region and day filter if set).
        You can drill down even further by clicking 'View Details' to see how the champion ranks in some URF worthy
        stats, and scroll down to see regional breakdowns of even more stats. Enjoy!
        </p>
        <h2>Disclaimer</h2>
        "4urf.com/For What It's URF" isn't endorsed by Riot Games and doesn't reflect the views or opinions of
        Riot Games or anyone officially involved in producing or managing League of Legends. League of Legends and
        Riot Games are trademarks or registered trademarks of Riot Games, Inc. League of Legends © Riot Games, Inc.
      </div>
    )