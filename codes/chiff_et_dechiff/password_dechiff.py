from cryptography.fernet import Fernet

# Charger la clé
def load_key():
    return open("secret.key", "rb").read()

# Déchiffrer un mot de passe
def decrypt_password(encrypted_password):
    key = load_key()  # Charger la clé
    fernet = Fernet(key)  # Créer un objet Fernet avec la clé
    decrypted_password = fernet.decrypt(encrypted_password).decode()  # Déchiffrer le mot de passe
    return decrypted_password

# Exemple d'utilisation
if __name__ == "__main__":
    # Remplacez ceci par votre mot de passe chiffré
    encrypted_password = b'gAAAAABnHMz4Tl3AkN8Mfcs3j17L0m-7_g-YsxL_YXDk0HdNaIFC9eodybrj_6wLkrGrfZ6UF5-og9Zm9QmfVCdtRNwjcs_NJQ=='  # Ajoutez ici votre mot de passe chiffré

    # Déchiffrement
    try:
        decrypted = decrypt_password(encrypted_password)
        print(f"Mot de passe déchiffré : {decrypted}")
    except Exception as e:
        print(f"Erreur lors du déchiffrement : {e}")
