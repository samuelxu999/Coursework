rps player_rxu22(int round,rps *myhist,rps *opphist) {
	
	int i=0;
	int i_scissors=0;
	int i_paper=0;
	int i_rock=0;
	int i_max=0;
	int i_index=0;
	
	//no history data, use random strategy
	if(NULL==myhist)
	{
		player_random(round,NULL,NULL);
	}
	//calculate frequency of opponent's action
	else
	{
		//for each opponent history data to make statistical calculation
		for(i==0;i<round;i++){
			//count frequent of Rock
			if(opphist[i]==Rock){
				i_rock++;
				continue;
			}
			//count frequent of Scissors
			if(opphist[i]==Scissors){
					i_scissors++;
					continue;
			}
			//count frequent of Paper
			if(opphist[i]==Paper){
					i_paper++;
					continue;
			}
		}
	}
	
	//find the max frequent strategy
	i_max=i_scissors;
	i_index=1;
	if(i_paper>i_max){
		i_max=i_paper;	
		i_index=2;
	}
	if(i_rock>i_max){
	        i_max=i_rock;
        	i_index=3;
	}
	//set strategy based on calculated data
	if(i_index==1)
		return Rock;
	if(i_index==2)
			return Scissors;
	if(i_index==3)
			return Paper;
}

register_player(player_rxu22,"rxu22");
