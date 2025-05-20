from cryptography.fernet import Fernet

# Générer une clé
def generate_key():
    key = Fernet.generate_key()
    with open("secret.key", "wb") as key_file:
        key_file.write(key)

# Charger la clé
def load_key():
    return open("secret.key", "rb").read()

# Chiffrer un mot de passe
def encrypt_password(password):
    key = load_key()
    fernet = Fernet(key)
    encrypted_password = fernet.encrypt(password.encode())
    return encrypted_password

# Utilisation
if __name__ == "__main__":
    # Générer une clé (exécutez cela une seule fois)
    generate_key()

    # Mot de passe à chiffrer
    password = "Password4.@#277"
    print(f"Mot de passe original : {password}")

    # Chiffrement
    encrypted = encrypt_password(password)
    print(f"Mot de passe chiffré : {encrypted}")


