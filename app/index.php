<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hello World!</title>
    <style>
        body {
            font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
            font-size: 14px;
            color: rgb(251, 251, 251);
            background-color: rgb(66, 68, 108);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 0;
            margin: 0;
            height: 100vh;
        }
        h1 {
            font-family: Cambria, Cochin, Georgia, Times, 'Times New Roman', serif;
        }
        a {
            padding-top: 2px;
            color: white;
        }
    </style>
</head>
<body>
    <h1>Hello World, PHP!</h1>
    <div>
        <b>PHP version:</b> <?= phpversion(); ?>
    </div>
    <a href="/about.php">Go to another page</a>
</body>
</html>