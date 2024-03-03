-- This file should be run via `busted -m lua`

local targets = require('chip-build.targets')

describe("Target iteration works", function()
  local test_targets = {
    {
      prefixes = { 'foo', { 'a', 'b', 'c' }, { 'x', 'y' } },
      suffixes = { 'bar', 'baz' }
    },
    {
      prefixes = { 'test', { '1', '2', '2' } },
      suffixes = {}
    }
  }

  local next_choice = function(c)
    local next, _ = targets.next_component_choices(c, { targets = test_targets })
    return next
  end

  it("shows top level items", function()
    assert.are.same(next_choice({}), { 'foo', 'test' })
  end)

  it("can get prefixes", function()
    assert.are.same(next_choice({ 'foo' }), { 'a', 'b', 'c' })
  end)

  it("can get suffixes", function()
    assert.are.same(next_choice({ 'foo', 'a', 'x' }), { 'bar', 'baz' })

    -- suffixes are trimmed
    assert.are.same(next_choice({ 'foo', 'a', 'x', 'bar' }), { 'baz' })
    assert.are.same(next_choice({ 'foo', 'a', 'x', 'bar', 'baz' }), {})
    assert.are.same(next_choice({ 'test', '1' }), {})
  end)
end)

describe("String splitting", function()
  it("splits strings", function()
    assert.are.same(targets.split_lines("test\nbar"), { 'test', 'bar' })
    assert.are.same(targets.split_lines("\ntest\n\n\nbar\n"), { 'test', 'bar' })

    assert.are.same(targets.split_lines([[
this-is
what-is-used
    ]]), { 'this-is', 'what-is-used' })
    assert.are.same(targets.split_lines([[
       ignores
       begin
       and-end
       whitespace
       embedded whitepace is ok
    ]]), {
      'ignores',
      'begin',
      'and-end',
      'whitespace',
      'embedded whitepace is ok'
    })
  end)
end)

describe("target_split", function()
  it('splits the start', function()
    assert.are.same(targets.split_target_string('foo'), {
      prefixes = { 'foo' },
      suffixes = {},
    })
    assert.are.same(targets.split_target_string('bar-'), {
      prefixes = { 'bar' },
      suffixes = {},
    })
    assert.are.same(targets.split_target_string('bar-baz'), {
      prefixes = { 'bar-baz' },
      suffixes = {},
    })
    assert.are.same(targets.split_target_string('bar-baz-'), {
      prefixes = { 'bar-baz' },
      suffixes = {},
    })
  end)

  it('splits groups', function()
    assert.are.same(targets.split_target_string('foo-{a,b}'), {
      prefixes = { 'foo', {'a', 'b'} },
      suffixes = {},
    })
    assert.are.same(targets.split_target_string('foo-{a,b}-{x,yz1,a-test}'), {
      prefixes = { 'foo', {'a', 'b'},  {'x', 'yz1', 'a-test'} },
      suffixes = {},
    })
  end)

  it('splits suffixes', function()
    assert.are.same(targets.split_target_string('foo-{a,b}[-foo]'), {
      prefixes = { 'foo', {'a', 'b'} },
      suffixes = {'foo'},
    })
    assert.are.same(targets.split_target_string('foo-{a,b}[-foo][-bar]'), {
      prefixes = { 'foo', {'a', 'b'} },
      suffixes = {'foo', 'bar'},
    })
    assert.are.same(targets.split_target_string('no-groups[-foo][-bar]'), {
      prefixes = { 'no-groups' },
      suffixes = {'foo', 'bar'},
    })
  end)
end)
