#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <winsock2.h>

#pragma comment(lib, "ws2_32.lib") // Nécessaire pour les sockets sous Windows

int main(int argc, char *argv[]) {
    WSADATA wsa;
    SOCKET socket_desc;
    struct sockaddr_in server;
    char message[2000], server_reply[2000];
    int recv_size;

    // Initialisation de Winsock
    printf("Initialising Winsock...\n");
    if (WSAStartup(MAKEWORD(2,2), &wsa) != 0) {
        printf("Failed. Error Code : %d", WSAGetLastError());
        return 1;
    }
    printf("Initialised.\n");

    // Création du socket
    if ((socket_desc = socket(AF_INET, SOCK_STREAM, 0)) == INVALID_SOCKET) {
        printf("Could not create socket : %d", WSAGetLastError());
        return 1;
    }
    printf("Socket created.\n");

    server.sin_addr.s_addr = inet_addr("127.0.0.1"); // Adresse IP du serveur
    server.sin_family = AF_INET;
    server.sin_port = htons(12345); // Port du serveur

    // Connexion au serveur distant
    if (connect(socket_desc, (struct sockaddr *)&server, sizeof(server)) < 0) {
        printf("Connect error");
        return 1;
    }
    printf("Connected\n");

    // Boucle principale pour les échanges avec le serveur
    while (1) {
        // Réception des messages du serveur
        if ((recv_size = recv(socket_desc, server_reply, sizeof(server_reply), 0)) == SOCKET_ERROR) {
            printf("recv failed");
            break;
        }

        // Ajout de la fin de chaîne à la réponse
        server_reply[recv_size] = '\0';
        printf("Server reply : %s\n", server_reply);

        // Demande de l'ID scanner
        if (strstr(server_reply, "Entrez ID scanner") != NULL) {
            printf("Client: ID scanner: ");
            fgets(message, sizeof(message), stdin);
            message[strcspn(message, "\n")] = '\0'; // Enlève le saut de ligne de l'entrée
            send(socket_desc, message, strlen(message), 0);
        }

        // Demande de l'ID de l'événement
        if (strstr(server_reply, "Entrez ID evenement") != NULL) {
            printf("Client: ID evenement: ");
            fgets(message, sizeof(message), stdin);
            message[strcspn(message, "\n")] = '\0'; // Enlève le saut de ligne de l'entrée
            send(socket_desc, message, strlen(message), 0);
        }

        // Demande de l'ID ticket
        if (strstr(server_reply, "Entrez ID ticket") != NULL) {
            printf("Client: ID ticket: ");
            fgets(message, sizeof(message), stdin);
            message[strcspn(message, "\n")] = '\0'; // Enlève le saut de ligne de l'entrée
            send(socket_desc, message, strlen(message), 0);
        }

        // Demande de confirmation
        if (strstr(server_reply, "Envoyez 'bien recu' pour confirmer") != NULL) {
            printf("Client: confirmation: ");
            fgets(message, sizeof(message), stdin);
            message[strcspn(message, "\n")] = '\0'; // Enlève le saut de ligne de l'entrée
            send(socket_desc, message, strlen(message), 0);

            // Attente de la réponse du serveur après confirmation
            if ((recv_size = recv(socket_desc, server_reply, sizeof(server_reply), 0)) == SOCKET_ERROR) {
                printf("recv failed");
                break;
            }
            server_reply[recv_size] = '\0';
            printf("Server reply : %s\n", server_reply);
        }

        // Demande d'envoyer 'fin' pour terminer la session
        if (strstr(server_reply, "Envoyez 'fin' pour terminer") != NULL) {
            printf("Client: 'fin' pour terminer: ");
            fgets(message, sizeof(message), stdin);
            message[strcspn(message, "\n")] = '\0'; // Enlève le saut de ligne de l'entrée
            send(socket_desc, message, strlen(message), 0);

            if (strcmp(message, "fin") == 0) {
                printf("Session terminee.\n");
                break; // Sortie de la boucle, fin du programme
            }
        }
    }

    // Fermeture du socket et nettoyage
    closesocket(socket_desc);
    WSACleanup();

    return 0;
}
