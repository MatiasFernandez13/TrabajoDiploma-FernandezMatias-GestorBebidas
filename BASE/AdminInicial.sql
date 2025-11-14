-- Usuario: admin
-- Contraseña: admin123
-- Salt: 1234-5678
-- Hash = SHA512("admin1231234-5678")
-- Resultado del hash (usando C# SeguridadService): 
-- xojP7ElR+pK5HEIxvKfUnZBRnKkiBy4mNB5FeKKNxaxL0WIXScwGFqLtkS5zWCRrEYpNjYhSqpH+aB5Ssj80ow==

INSERT INTO Usuarios (NombreUsuario, Contraseña, Salt, RolId)
VALUES (
    'admin',
    'xojP7ElR+pK5HEIxvKfUnZBRnKkiBy4mNB5FeKKNxaxL0WIXScwGFqLtkS5zWCRrEYpNjYhSqpH+aB5Ssj80ow==',
    '1234-5678',
    1
);
