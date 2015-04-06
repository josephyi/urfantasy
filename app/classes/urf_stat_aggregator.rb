class UrfStatAggregator
  CHAMPION_ID_KEY = 'championId'.freeze

  def self.aggregate(region:, day:, hour:, matches:)
    process_matches!(stats: init_stats(region: region, hour: hour, day: day), matches: matches)
  end

  def self.init_stats(region:, hour:, day:)
    StaticData::CHAMPION_IDS.each_with_object({}) do |id, hash|
      hash[id] = {
          region: region,
          hour: hour,
          day: day,
          kills: 0,
          deaths: 0,
          assists: 0,
          double_kills: 0,
          triple_kills: 0,
          quadra_kills: 0,
          penta_kills: 0,
          killing_spree_max: 0,
          first_blood: 0,
          minions_killed: 0,
          bans: 0,
          wins: 0,
          losses: 0,
          mirror_matches: 0
      }
    end
  end

  # refactor lel
  def self.process_matches!(stats:, matches:)
    matches.each do |match|
      response = match.response

      # update bans
      merge_ban_stats!(stats: stats, teams: response['teams'.freeze]) rescue puts "broken on #{match.id}"

      # crappy hash logic for mirror match count :/
      hash = Hash.new { |hash, key| hash[key] = [] }
      response['participants'.freeze].each{|participant|
        merge_participant_stats!(stats: stats, participant: participant)
        hash[participant['teamId']] << participant[CHAMPION_ID_KEY]
      }
      merge_mirror_match_stats(stats: stats, team_champ_hash: hash)
    end
    stats
  end



  def self.merge_ban_stats!(stats:, teams:)
    teams.flat_map{|team| team['bans'.freeze]}.compact
        .map{|ban| ban[CHAMPION_ID_KEY]}
        .each{|champion_id| stats[champion_id].merge!(bans: 1){|k1,v1,v2| v1 + v2 }}
    stats
  end

  def self.merge_participant_stats!(stats:, participant: )
    participant_stats = participant['stats']
    stats[participant['championId']].merge!(
        kills: participant_stats['kills'.freeze],
        deaths: participant_stats['deaths'.freeze],
        assists: participant_stats['assists'.freeze],
        double_kills: participant_stats['doubleKills'.freeze],
        triple_kills: participant_stats['tripleKills'.freeze],
        quadra_kills: participant_stats['quadraKills'.freeze],
        penta_kills: participant_stats['pentaKills'.freeze],
        first_blood: participant_stats['firstBloodKill'.freeze] ? 1 : 0,
        minions_killed: participant_stats['minionsKilled'.freeze],
        wins: participant_stats['winner'.freeze] ? 1 : 0,
        losses: participant_stats['winner'.freeze] ? 0 : 1
    ){|k1,v1,v2| v1 + v2 }
    stats[participant[CHAMPION_ID_KEY]].merge!(killing_spree_max: participant_stats['killingSprees']){|k1, v1, v2| [v1, v2].max }
  end

  def self.merge_mirror_match_stats(stats:, team_champ_hash:)
    values = team_champ_hash.values
    (values[0] & values[1]).each{|champion_id|
      stats[champion_id].merge!(mirror_matches: 1){|k1,v1,v2| v1 + v2 }
    }
    stats
  end
end