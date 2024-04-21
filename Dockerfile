FROM node:latest AS builder


RUN groupadd -r nodejs -g 433 && \
    useradd -u 431 -r -g nodejs -s /sbin/nologin -c "Docker image user" nodejs

# Créer un répertoire pour l'application et on change la propriété de ce répertoire à notre nouvel utilisateur
RUN mkdir /home/nodejs && \
    chown -R nodejs:nodejs /home/nodejs

# Changer l'utilisateur courant à notre nouvel utilisateur
USER nodejs

WORKDIR /home/nodejs
COPY --chown=nodejs:nodejs package*.json ./
COPY --chown=nodejs:nodejs . .
RUN npm install  

# Créer une nouvelle image à partir de l'image de base Node.js
FROM node:latest

WORKDIR /home/nodejs

# Copier les dépendances et le code construit depuis l'image builder
COPY --from=builder --chown=nodejs:nodejs /home/nodejs .

# Exposer le port sur lequel l'application va s'exécuter
EXPOSE 3000

# Définir la commande pour démarrer l'application
CMD ["npm", "start"]