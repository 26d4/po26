<?php

namespace App\Controller;

use App\Entity\Product;
use App\Form\ProductType;
use App\Repository\ProductRepository;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Serializer\SerializerInterface;
use Symfony\Component\Validator\Validator\ValidatorInterface;
use Symfony\Component\HttpKernel\Exception\BadRequestHttpException;

#[Route('/api/product')]
final class JsonProductController extends AbstractController
{
	#[Route(name: 'app_json_product_index', methods: ['GET'], format: 'json')]
	public function index(ProductRepository $productRepository): Response
	{
		return $this->json($productRepository->findAll());
	}

	#[Route(name: 'app_json_product_new', methods: ['POST'], format: 'json')]
	public function new(Request $request, EntityManagerInterface $entityManager, SerializerInterface $serializer, ValidatorInterface $validator): Response
	{
		if ('json' !== $request->getContentTypeFormat()) {
			return $this->json(['message' => 'Unsupported content format'], 400);
		}

		$jsonData = $request->getContent();
		$product = $serializer->deserialize($jsonData, Product::class, 'json');
		
		$errors = $validator->validate($product);
		if (count($errors) > 0) {
			return $this->json(['message' => (string) $errors], 400);
		}
		
		$entityManager->persist($product);
		$entityManager->flush();
		
		return $this->json($product, status: Response::HTTP_CREATED);
	}

	#[Route('/{id}', name: 'app_json_product_show', methods: ['GET'], format: 'json')]
	public function show(Product $product): Response
	{
		return $this->json($product);
	}

	#[Route('/{id}', name: 'app_json_product_edit', methods: ['PATCH', 'PUT'], format: 'json')]
	public function edit(Request $request, Product $product, EntityManagerInterface $entityManager, SerializerInterface $serializer, ValidatorInterface $validator): Response
	{
		if ('json' !== $request->getContentTypeFormat()) {
			return $this->json(['message' => 'Unsupported content format'], 400);
		}

		$jsonData = $request->getContent();
		$productMod = $serializer->deserialize($jsonData, Product::class, 'json');
		
		$errors = $validator->validate($productMod);
		if (count($errors) > 0) {
			return $this->json(['message' => (string) $errors], 400);
		}
		
		if ($request->getMethod() === 'PUT') {
			$diff = array_diff($entityManager->getClassMetadata(Product::class)->getFieldNames(), array_keys(json_decode($jsonData, true)));
			$diff = array_diff($diff, array('id'));
			if (count($diff) > 0) {
				return $this->json(['message' => "Missing fields", 'missing_fields' => array_values($diff)], 400);
			}
		}
		
		$serializer->deserialize($jsonData, Product::class, 'json', ['object_to_populate' => $product]);
		$entityManager->flush();
		
		return $this->json($product);
	}

	#[Route('/{id}', name: 'app_json_product_delete', methods: ['DELETE'], format: 'json')]
	public function delete(Product $product, EntityManagerInterface $entityManager): Response
	{
		$entityManager->remove($product);
		$entityManager->flush();

		return $this->json(null, Response::HTTP_NO_CONTENT);
	}
}
