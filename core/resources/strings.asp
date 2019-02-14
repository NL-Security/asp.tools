<%
function LoadResources()
    resources.addcatalog "fr", "strings"
    with resources.Item("fr")("strings")
        .add "creation", "Création"
        .add "edition", "Modification"
        .add "details", "Fiche"
        .add "ajouter", "Ajouter"
        .add "create", "Ajouter"
        .add "modifier", "Modifier"
        .add "supprimer", "Supprimer"
        .add "save", "Enregistrer"
        .add "home", "Accueil"
        .add "admin", "Paramétrage"
        .add "login", "Se connecter"
        .add "logout", "Se déconnecter"
        .add "general", "Général"
        .add "affichage", "Affichage"
        .add "affichages", "Affichages"
        .add "edition", "Edition"
        .add "editions", "Editions"
        .add "nc", "NC"
    end with
end function
%>