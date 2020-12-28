package main

import (
	"fmt"
	"sort"
	"strings"
	"utils/utils"
)

type Ingredient = string

type Food = []Ingredient

type Allergen = string

func inAllFoods(ing Ingredient, foods []Food) bool {
	for _, food := range foods {
		if _, found := utils.FindStr(food, ing); !found {
			return false
		}
	}
	return true
}

func Allergens(occur map[Allergen][]Food, ings map[Ingredient]bool) map[Ingredient]Allergen {
	poss := make(map[Allergen][]Ingredient)

	for allergen, foods := range occur {
		for ing := range ings {
			if inAllFoods(ing, foods) {
				poss[allergen] = append(poss[allergen], ing)
			}
		}
	}

	allergens := make(map[Ingredient]Allergen)
	for len(allergens) != len(poss) {
		for a, pings := range poss {
			if len(pings) == 1 {
				ing := pings[0]
				if _, fixed := allergens[ing]; !fixed {
					allergens[ing] = a
					for aa, ppings := range poss {
						if a != aa {
							poss[aa] = utils.DeleteStr(ppings, ing)
						}
					}
				}
			}
		}
	}

	return allergens
}

type IA struct {
	ingredient Ingredient
	allergen   Allergen
}

func sortByAllergen(allergens map[Ingredient]Allergen) []IA {
	var slice []IA
	for i, a := range allergens {
		slice = append(slice, IA{i, a})
	}

	sort.Slice(slice, func(i, j int) bool {
		return slice[i].allergen < slice[j].allergen
	})

	return slice
}

func main() {
	occur := make(map[Allergen][]Food)
	ingredients := make(map[Ingredient]bool)

	var foods []Food

	utils.ScanLine("big.txt", func(line string) {
		line = strings.ReplaceAll(line, "(", "")
		line = strings.ReplaceAll(line, ")", "")
		split := strings.Split(line, " contains ")

		food := strings.Split(split[0], " ")

		for _, ing := range food {
			ingredients[ing] = true
		}

		foods = append(foods, food)
		for _, a := range strings.Split(split[1], ", ") {
			occur[a] = append(occur[a], food)
		}
	})

	allergens := Allergens(occur, ingredients)
	safe := 0
	for _, food := range foods {
		for _, ing := range food {
			if _, found := allergens[ing]; !found {
				safe++
			}
		}
	}

	fmt.Println("Part 1: ", safe)

	sorted := sortByAllergen(allergens)

	res := ""
	for _, ing := range sorted {
		res += ing.ingredient + ","
	}
	res = strings.TrimRight(res, ",")

	fmt.Println("Part 2: ", res)
}
