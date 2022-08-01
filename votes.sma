#include <amxmodx>
#include <cromchat>

#include "include/credits.inc"
#include "include/sockets_hz.inc"

#define LISTEN_IP "93.114.82.74"
#define LISTEN_PORT 27014

new g_pcvar_reward;

new g_vote_reward;

new g_socket;

public plugin_init(){
	g_pcvar_reward = register_cvar("votes_reward", "500");

	g_vote_reward = get_pcvar_num(g_pcvar_reward);

	hook_cvar_change(g_pcvar_reward, "reward_changed_callback");

	CC_SetPrefix("&x04[LLG]");
}

public plugin_cfg(){
	listen();
}

public plugin_end(){
	socket_close(g_socket);
}


public reward_changed_callback(pcvar, const old_value[], const new_value[]){
	g_vote_reward = str_to_num(new_value);
}

public listen(){
	new error;
	
	g_socket = socket_listen(LISTEN_IP, LISTEN_PORT, SOCKET_TCP, error);

	if( !g_socket) {
		log_amx("Error: Could not listen on %s:%d", LISTEN_IP, LISTEN_PORT);
	}
	log_amx("Trying to listen on %s:%d", LISTEN_IP, LISTEN_PORT);
	socket_unblock(g_socket);

	set_task(1.0, "accept_reply", 1337, _, _, "b");

}

public accept_reply(task_id){
	new data[512];

	new socket_client = socket_accept(g_socket);

	if(socket_client < 0) return;

	socket_recv(socket_client, data, charsmax(data));

	socket_close(socket_client);

	log_amx("Rewarding Player: %s", data);
	reward(data);
}



public reward(player[]){
	set_user_credits_name(player, get_user_credits_name(player) + g_vote_reward);
	CC_SendMessage(0, "Jucatorul &x04%s &x01a primit &x04%d credite &x01pentru ca a votat server-ul!", player, g_vote_reward);
}