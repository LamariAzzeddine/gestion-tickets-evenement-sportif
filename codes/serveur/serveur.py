import socket
from datetime import datetime
import configparser
import psycopg2

# Lire le fichier de configuration
config = configparser.ConfigParser()
config.read(r'C:\Users\dell-5320\Desktop\codes_client_serveur\codes_client_serveur\serveur\config.ini')

# Obtenir les informations de connexion
db_config = config['postgresql']

# Se connecter à la base de données PostgreSQL
try:
    connection = psycopg2.connect(
        host=db_config['host'],
        database=db_config['database'],
        user=db_config['user'],
        password=db_config['password'],
        port=db_config['port']
    )
    
    # Créer un curseur
    cursor = connection.cursor()

    # Fonction pour vérifier si un ticket est expiré
    def est_ticket_expire(id_ticket):
        
        # Exécuter une requête (exemple)
        cursor.execute(f"SELECT evenement.dateevenement, evenement.heurefinevenement FROM ticket JOIN evenement ON ticket.idevenement = evenement.idevenement WHERE ticket.idticket = '{id_ticket}';")

        # Récupérer le résultat
        result_requete6 = cursor.fetchone()  # Utilisez fetchone() pour un seul résultat
        
        date_evenement = result_requete6[0]  # Stocker la date de l'événement dans une variable
        heure_fin_evenement = result_requete6[1]  # Stocker l'heure de fin dans une variable
        print("Date de l'événement :", date_evenement)
        print("Heure de fin de l'événement :", heure_fin_evenement)

        # Combiner date et heure pour obtenir un datetime sans fuseau horaire
        datetime_fin_evenement = datetime.combine(date_evenement, heure_fin_evenement)

        # Obtenir l'heure actuelle
        now = datetime.now()

        return now > datetime_fin_evenement

    def access_authorized(client_socket):
        client_socket.sendall("Acces autorise\n\n".encode('utf-8'))
        print("Acces autorise.")
        client_socket.sendall("Envoyez 'bien recu' pour confirmer".encode('utf-8'))
        confirmation = client_socket.recv(1024).decode('utf-8').strip()
        if confirmation == "bien recu":
            print("Confirmation recue.")
            client_socket.sendall(b"Envoyez 'fin' pour terminer")
            fin = client_socket.recv(1024).decode('utf-8').strip()
            if fin == "fin":
                print("Connexion fermee par le client.")
                client_socket.sendall(b"fin, Fermeture connexion...\n")
                client_socket.close()

    def access_denied(client_socket, reason):
        client_socket.sendall(f"Acces refuse\nRaison: {reason}\n".encode('utf-8'))
        print(f"Acces refuse: {reason}")
        client_socket.sendall("Envoyez 'bien recu' pour confirmer".encode('utf-8'))
        confirmation = client_socket.recv(1024).decode('utf-8').strip()
        if confirmation == "bien recu":
            print("Confirmation recue.")
            client_socket.sendall(b"Envoyez 'fin' pour terminer")
            fin = client_socket.recv(1024).decode('utf-8').strip()
            if fin == "fin":
                print("Connexion fermee par le client.")
                client_socket.sendall(b"fin, Fermeture connexion...\n")
                client_socket.close()

    def handle_client(client_socket):
        client_socket.sendall("Entrez ID scanner".encode('utf-8'))
        id_scanner = client_socket.recv(1024).decode('utf-8').strip()
        print(f"ID scanner recu : {id_scanner}")
        
        cursor.execute(f"SELECT COUNT(*) FROM scanner WHERE idscanner = '{id_scanner}';")
        # Récupérer le résultat
        result_requete1 = cursor.fetchone()  # Utilisez fetchone() pour un seul résultat
        # Afficher le résultat
        print("Nombre de scanners avec cette id :", result_requete1[0])  # Le premier élément du tuple
        
        if result_requete1[0]== 0:
            access_denied(client_socket, "Scanner invalide")
            return
        else:
            client_socket.sendall(b"Scanner valide\n")

        client_socket.sendall("Entrez ID evenement".encode('utf-8'))
        id_evenement = client_socket.recv(1024).decode('utf-8').strip()
        print(f"ID evenement recu : {id_evenement}")
        
        cursor.execute(f"SELECT COUNT(*) FROM evenement WHERE idevenement = '{id_evenement}';")
        # Récupérer le résultat
        result_requete2 = cursor.fetchone()  # Utilisez fetchone() pour un seul résultat
        # Afficher le résultat
        print("Nombre devenement avec cette id :", result_requete2[0])  # Le premier élément du tuple
        if result_requete2[0]== 0:
            access_denied(client_socket, "Evenement invalide")
            return
        else:
            client_socket.sendall(b"Evenement valide\n")

        client_socket.sendall("Entrez ID ticket".encode('utf-8'))
        id_ticket = client_socket.recv(1024).decode('utf-8').strip()
        print(f"ID ticket recu : {id_ticket}")
        
                
        
        cursor.execute(f"SELECT COUNT(*) FROM ticket WHERE idticket = '{id_ticket}';")
        # Récupérer le résultat
        result_requete3 = cursor.fetchone()  # Utilisez fetchone() pour un seul résultat
        # Afficher le résultat
        print("Nombre de ticket avec cette id :", result_requete3[0])  # Le premier élément du tuple
        if result_requete3[0]== 0:
            access_denied(client_socket, "Ticket inexistant")
            return
        
        
        # inserer idticket et idscanner a la table peut etre scanne
    
        # Vérifier si l'idticket et idscanner existent déjà dans la table
        cursor.execute(f"SELECT COUNT(*) FROM peutetrescanne WHERE idticket = '{id_ticket}' AND idscanner = '{id_scanner}';")
        result = cursor.fetchone()

        if result[0] == 0:  # Si le résultat est 0, cela signifie que la combinaison n'existe pas
            # Insérer idticket et idscanner dans la table peutetrescanne
            cursor.execute(f"INSERT INTO peutetrescanne (idticket, idscanner) VALUES ('{id_ticket}', '{id_scanner}');")
            connection.commit()  # Valider l'insertion
            print("Insertion réussie.")
        else:
            print("La combinaison idticket et idscanner existe déjà.")

        # Exécuter une requête (exemple)
        cursor.execute(f"SELECT COUNT(*) FROM ticketvalide WHERE id_ticket_valide = '{id_ticket}';")
    
        # Récupérer le résultat
        result_requete4 = cursor.fetchone()  # Utilisez fetchone() pour un seul résultat
    
    # Afficher le résultat
        print("Nombre de ticket valide scanne avec cette id :", result_requete4[0])  # Le premier élément du tuple
        if result_requete4[0] > 0:
            access_denied(client_socket, "Ticket valide deja scanne")
            return
                
        cursor.execute(f"SELECT COUNT(*) FROM ticket WHERE idticket = '{id_ticket}' AND idevenement = '{id_evenement}';")
    
        # Récupérer le résultat
        result_requete5 = cursor.fetchone()  # Utilisez fetchone() pour un seul résultat
    
        # Afficher le résultat
        print("Nombre devenement associés au ticket:", result_requete5[0])  # Le premier élément du tuple
        if result_requete5[0] == 0:
            access_denied(client_socket, "Evenement non autorise")
            return


        if est_ticket_expire(id_ticket):
            access_denied(client_socket, "Ticket expire")
            return
        
        # Exécuter une requête (exemple)
        cursor.execute(f"SELECT zone.nomzone FROM ticket JOIN place ON ticket.idevenement = place.idevenement JOIN zone ON place.idzone = zone.idzone WHERE ticket.idticket = '{id_ticket}';")
        
        # Récupérer le résultat
        result_requete7 = cursor.fetchone()  # Utilisez fetchone() pour un seul résultat
        
        Nom_de_la_zone=result_requete7[0]

        # Afficher le résultat
        print("Nom de la zone associe au ticket:",Nom_de_la_zone)
        


        # Exécuter une requête (exemple)
        cursor.execute(f"SELECT emplacement FROM scanner WHERE idscanner='{id_scanner}';")
        
        # Récupérer le résultat
        result_requete8= cursor.fetchone()  # Utilisez fetchone() pour un seul résultat
        
        Emplacement_du_scanner=result_requete8[0]

        # Afficher le résultat
        print("Emplacement du scanner:",Emplacement_du_scanner)
            
        if  Nom_de_la_zone == Emplacement_du_scanner :
            
            heure_de_scan_du_ticket = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
            cursor.execute(f"INSERT INTO ticketvalide (idlogscan, heurescan,id_ticket_valide,idscanner) VALUES ('LOG' || LPAD(CAST((SELECT COUNT(*) FROM ticketvalide) + 1 AS TEXT), 3, '0'),'{heure_de_scan_du_ticket}', '{id_ticket}' ,'{id_scanner}');")
            connection.commit()  # Assurez-vous de valider l'insertion
            

            access_authorized(client_socket)
        else:
            access_denied(client_socket, "Mauvaise zone")
        
except Exception as error:
    print("Erreur lors de la connexion à la base de données :", error)

def main():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server_socket.bind(('127.0.0.1', 12345))
    server_socket.listen(5)
    print("Serveur ecoute sur port 12345.")
    
    while True:
        client_socket, addr = server_socket.accept()
        print(f"Connexion avec {addr}")
        handle_client(client_socket)

if __name__ == "__main__":
    main()
