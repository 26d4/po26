<?php

namespace App\Controller;

use App\Entity\Article;
use App\Form\ArticleType;
use App\Repository\ArticleRepository;
use App\Repository\UserRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Serializer\SerializerInterface;
use Symfony\Component\Validator\Validator\ValidatorInterface;
use Psr\Log\LoggerInterface;

#[Route('/api/article')]
final class JsonArticleController extends AbstractController
{
	#[Route(name: 'app_json_article_index', methods: ['GET'], format: 'json')]
	public function index(ArticleRepository $articleRepository): Response
	{
		return $this->json($articleRepository->findAll());
	}
	
	#[Route(name: 'app_json_article_new', methods: ['POST'], format: 'json')]
	public function new(Request $request, EntityManagerInterface $entityManager, SerializerInterface $serializer, ValidatorInterface $validator, UserRepository $userRepository, LoggerInterface $logger): Response
	{
		if ('json' !== $request->getContentTypeFormat()) {
			return $this->json(['message' => 'Unsupported content format'], 400);
		}

		$jsonData = $request->getContent();
		$article = $serializer->deserialize($jsonData, Article::class, 'json');
		
		$errors = $validator->validate($article);
		if (count($errors) > 0) {
			return $this->json(['message' => (string) $errors], 400);
		}
		
		$logger->debug('ARTICLE AUTHOR {a}', ['a' => $request->getPayload()->get('author')]);
		
		$article->setAuthor($userRepository->find($request->getPayload()->get('author'))); // more doctrine bullshit
		$entityManager->persist($article);
		$entityManager->flush();
		
		return $this->json($article, status: Response::HTTP_CREATED);
	}

	#[Route('/{id}', name: 'app_json_article_show', methods: ['GET'], format: "json")]
	public function show(Article $article): Response
	{
		return $this->json($article);
	}
	
	#[Route('/{id}', name: 'app_json_article_edit', methods: ['PATCH'], format: 'json')]
	public function edit(Request $request, Article $article, EntityManagerInterface $entityManager, SerializerInterface $serializer, ValidatorInterface $validator): Response
	{
		if ('json' !== $request->getContentTypeFormat()) {
			return $this->json(['message' => 'Unsupported content format'], 400);
		}

		$jsonData = $request->getContent();
		$articleMod = $serializer->deserialize($jsonData, Article::class, 'json');
		
		$errors = $validator->validate($articleMod);
		if (count($errors) > 0) {
			return $this->json(['message' => (string) $errors], 400);
		}
		
//		if ($request->getMethod() === 'PUT') {
//			$diff = array_diff($entityManager->getClassMetadata(article::class)->getFieldNames(), array_keys(json_decode($jsonData, true)));
//			$diff = array_diff($diff, array('id'));
//			if (count($diff) > 0) {
//				return $this->json(['message' => "Missing fields", 'missing_fields' => array_values($diff)], 400);
//			}
//		}
		
		$serializer->deserialize($jsonData, article::class, 'json', ['object_to_populate' => $article]);
		$entityManager->flush();
		
		return $this->json($article);
	}

	#[Route('/{id}', name: 'app_json_article_delete', methods: ['DELETE'], format: 'json')]
	public function delete(Request $request, Article $article, EntityManagerInterface $entityManager): Response
	{
		$entityManager->remove($article);
		$entityManager->flush();

		return $this->json(null, Response::HTTP_NO_CONTENT);
	}
}
