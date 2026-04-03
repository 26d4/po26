<?php
// src/Controller/LuckyController.php
namespace App\Controller;

use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class HomeController
{
	#[Route('/')]
    public function home(): Response
    {
        return new Response(
            '<html><body><ul><li><a href=/product>Products</a></li><li><a href=/user>Users</a></li><li><a href=/article>Articles</a></li></ul></body></html>'
        );
    }
}
