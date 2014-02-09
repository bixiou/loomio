angular.module('loomioApp').service 'd3Helpers',
	class d3Helper
		proposalArray: (proposal) ->
			votes = ['yes_votes', 'no_votes', 'abstain_votes', 'block_votes']
			if proposal.votes_count is 0
				datum = {type:'none', count:1}
				array = [datum]
			else
				array = (@voteDatum vote, proposal for vote in votes)
			return array

		voteDatum:(vote, proposal) ->
			key = vote + '_count'
			datum = 
				type: vote
				count: proposal[key]	

		setPieInitData: (proposal, pie) ->
			## if the proposal was created < 3000ms ago initiate piechart with endAngle = 0
			## so it animates on proposal creation  
			now = moment()
			proposalStarted = moment proposal.created_at
			if now.diff(proposalStarted) < 3000
				initData = [
					startAngle: 0
					endAngle: 0
					value: 0
					data:
						type: 'none'
						count: 0 ]
			else
				initData = pie(@.proposalArray(proposal))
			return initData

		setChartAttrs: (element, size) ->
			r = size/2
			svg = d3.select(element[0]).select('svg') 
			svg = if svg[0][0] then svg else d3.select(element[0]).append('svg')
			g = svg.select('g') 
			g = if g[0][0] then g else svg.append('g').attr('id', 'arcs')

			svg.attr('width', size)
			   .attr('height', size)
			
			g.attr('transform', 'translate('+r+','+r+')')



